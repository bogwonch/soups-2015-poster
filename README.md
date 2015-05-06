Introduction
============

Phones and mobile devices let users choose the software they want to run. App stores offer a wide range of apps for users to pick from. Users make the decision of which apps to use based on their own policies. Sometimes this is based on what the store shows them first , other times it is based on information about the app—ratings and the permissions it requests .

There is some evidence that users tend to fall into patterns when picking apps . By capturing these policies explicitly they can be enforced more consistently by a machine, lessening the burden on users to decide which apps they want. Furthermore whilst some expert users could write their own policies formally, others just want help. By sharing policies users can gain the benefits of expert written security policies without having to become experts themselves

Policies and AppPAL
===================

AppPAL
------

To write policies we have used the AppPAL authorization logic. AppPAL is a language, based on SecPAL , that can describe what it means for an app to be installable. AppPAL requires all statements be made by an explicit speaker, which enables rich delegation relationships to be expressed in policies. AppPAL is implemented as a Java library and runs on the Java and Dalvik virtual machines.

Alice, a user, can state that a specific app is installable.

    "alice" says "com.rovio.angrybirds" isInstallable.

Alternately she can specify that an app is only installable if a set of constraints (facts checkable by inspecting the app directly, or by static analysis) are met. She can also delegate parts of the decision to third parties, who intern must state facts about an app for it to be accepted. An example might be a that she will only install apps without the `LOCATION` permission that meet her *not-malware* policy (which she trusts McAfee to decide for her).

    "alice" says App isInstallable
      if "not-malware-policy" isMetBy(App)
      where hasPermission(App, "LOCATION") = False.

    "alice" says "mcafee" can-say 0
      "not-malware-policy" isMetBy(App).

Policies
--------

Lin <span>et<span>.</span> al<span>.</span></span> showed that users fall into four behaviour patterns when picking apps . Conservative users felt uncomfortable allowing an app access to any personal data or functionality for any reason; unconcerned users felt okay allowing access to any data for almost any reason. Advanced users were more picky, for example comfortable allowing apps access to location data for core functionality but not for advertising purposes; whereas fence sitters (the largest cluster) varied about what they found uncomfortable but were broadly against collection of personal data for advertising purposes.

Using these behaviors as a start point we wrote the following AppPAL policies to describe their behaviour, each of increasing strictness:

    User says "unconcerned-policy" isMetBy(App)
      if app isAnApp
      where 
        hasPermission(App, "GET_ACCOUNTS") = False.
            
    User says "fencesitter-policy" isMetBy(App)
      if "unconcerned-policy" isMetBy(App)
      where 
        hasPermission(App, "ACCESS_FINE_LOCATION") = False,
        hasPermission(App, "READ_CONTACT") = False.

    User says "advanced-policy" isMetBy(App)
      if "fencesitter-policy" isMetBy(App)
      where 
        hasPermission(App, "READ_PHONE_STATE") = False,
        hasPermission(App, "SEND_SMS") = False,

    User says "conservative-policy" isMetBy(App)
      if "advanced-policy" isMetBy(App)
      where 
        hasPermission(App, "ACCESS_COARSE_LOCATION") = False.

We also add two additional policies. These policies use the categorization of apps (by the stores) to specify which policies based on how we might expect different kinds of apps to behave. A user might use app with in-app-purchases in general but decline games with them as they can be *Cow Clickers*.

    User says "iap-policy" isMetBy(App)
      if app isAnApp
      where
        hasGooglePlayCategory(App, "GAME") = False.

    User says "iap-policy" isMetBy(App)
      if app isAnApp
      where
        hasGooglePlayCategory(App, "GAME") = True,
        hasPermission(App, "com.android.vending.BILLING") = False.

-   Another policy

Experiments
===========

Aims
----

We have two aims:to introduce AppPAL as a language for modelling and describing app installation policies, and to measure the extent users currently enforce app installation policies.

Assumptions
-----------

-   Downloaded apps used for experiments are not the same version as those used by users; and may have different permissions. Permissions tend to grow in apps over time  (in part due to increased system permissions) so we might find the apps allowed are more permissive now than when the user installed them.

-   We do not have the full user purchase history. We can only test policies on the apps we know about. Consequently a user may have apps installed that break the policy, but which we do not know. This is a limitation of the Carat data set.

Methodology
-----------

We want to test how well these policies capture user behavior. The Carat project  have a large, partially anonymized[1], database of app installations by users. By calculating the hash of a package name you can see which users installed which apps.

From an initial database of over 90,000 apps, and 55,000 users who on average installed just under 90 apps each, we unmasked 4,300 apps (on average half the users installs). Disregarding system apps (such as `com.android.vending`) and very common apps such as Facebook, Dropbox, Whatsapp, and Twitter we further reduced the set to an average of twenty apps per user that they installed.

Using this data, and the apps themselves collected from the Google Play Store and Android Observatory  we checked which apps satisfied which AppPAL policies. From here we created a table of whether a user’s apps satisfied a policy.

Results
-------

Discussion
==========

-   We found...

Next steps will involve a trial creating an app store for Android with AppPAL built in. This will allow us to trial the system with users, and expert users to begin exploring policies to address their concerns.

[1] Users are replaced with incrementing numbers, apps with hashes.
