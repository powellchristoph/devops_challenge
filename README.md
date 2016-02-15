# DevOps Challenge
---------
**Application Requirements**

- Build a simple application using the framework of your choice with one method GET /ping that returns "pong!" as a response.
- Setup a simple CI/CD system that based on merges to master will gracefully (without downtime) deploy the application.
- The choice of tools is yours!  Use whatever you are most familiar with or something you’ve been interested in exploring if you wish.

**Code Requirements**
- Use Github – please invite <users> to the project.
- Please try to write close to production-quality code (whatever this means to you)
- Please include instructions for how and where we should test your project.

At the end of the Ansible run, it will print out the URL of the loadbalancer.
```
TASK [debug] *******************************************************************
ok: [localhost] => {
    "msg": "Site available at http://146.20.48.247"
}

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0
web-iad-01                 : ok=17   changed=4    unreachable=0    failed=0
web-iad-02                 : ok=17   changed=4    unreachable=0    failed=0
web-iad-03                 : ok=17   changed=4    unreachable=0    failed=0
```
