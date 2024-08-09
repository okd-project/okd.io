# Documentation

<!--- cSpell:ignore mburke dmueller -->

There are 2 primary sources of information for OKD:  

- community documentation - [https://okd.io](https://okd.io){: target=blank} (this site)
- product documentation - [https://docs.okd.io](https://docs.okd.io){: target=blank}

## Updates and Issues

If you encounter an issue with the documentation or have an idea to improve the content or add new content then please follow the directions below to learn how you can get changes made.

The source for the documentation is managed in GitHub. There are different processes for requesting changes in the community and product documentation:

### Community documentation

The [OKD Documentation subgroup](wg_docs/overview.md){: target=_blank} is responsible for the community documentation.  The process for making changes is set out in the [working group section of the documentation](wg_docs/okd-io.md){: target=_blank}

### Product documentation

The OKD docs are built off the [openshift/openshift-docs](https://github.com/openshift/openshift-docs/){: target=_blank} repo. If you notice any problems in the OKD docs that need to be addressed, you can either create a pull request with those changes against the [openshift/openshift-docs](https://github.com/openshift/openshift-docs/){: target=_blank} repo or [create an issue](https://github.com/openshift/openshift-docs/issues/new){: target=_blank} to suggest the changes.

Among the changes you could suggest are:

- errors
- typos
- missing information
- incorrect product name (OpenShift Container Platform instead of OKD)
- Incorrect operating system (RHEL or RHCOS instead of FCOS)
- incorrect code examples

If you create an issue, please do the following:

- Add [OKD] to the title of the issue.
- Provide as much information as possible, including the problem, the exact location in the file, the versions of OKD that the error affects (if known), and the correction you would like to see. A link to the file with the problem is extremely helpful.
- If you have the appropriate permissions, assign the issue to Michael Burke (mburke5678) so that the issue gets our direct attention.  You can assign an issue by including the following in the issue description:

    ```text
    /assign @mburke5678
    ```

    If not, you can @ mention mburke5678 in a comment.
- If you have the permissions, add a `kind/documentation` label.

#### Testing changes locally

Before opening a pull request, you might want to inspect your changes locally. To do this you will need to use [podman](https://podman.io) or [docker](https://docker.com). After cloning the openshift-docs repository, run the following command inside the root of the repository:

```shell
podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder asciibinder build --distro openshift-origin
```

_Note: substitute `docker` for `podman` if you are using docker instead_

If this process succeeds, you will find the rendered output files in `./_preview/openshift-origin/latest/`. To view the landing page for the documentation version built, open `./_preview/openshift-origin/latest/welcome/index.html` in your browser.

There are 2 caveats to be aware of when building the site locally:

1. you will most likely see some error output that looks like this:
  ```text
  WARN: The following branches do not exist in your local git repo:
  - enterprise-3.10
  - enterprise-3.11
  - enterprise-3.6
  - enterprise-3.7
  - enterprise-3.9
  - enterprise-4.11
  - enterprise-4.6
  - enterprise-4.7
  The build will proceed but these branches will not be generated.
  WARN: The /docs/_topic_map.yml20230919-1-628e1m file on branch 'OSDOCS-7251-Azure-CPMS-mutli-subnet' references 215 nonexistent topics. Set logging to 'debug' for details.
  WARN: Branch OSDOCS-7251-Azure-CPMS-mutli-subnet includes 6073 files that are not referenced in the /docs/_topic_map.yml20230919-1-bhydnn file. Set logging to 'debug' for details.
  ```
  This is a normal type of warning produced by the build process and doesn't necessarily need investigating.
1. The root index file will be `./index-community.html`, but this file does not link properly to the content in `./_preview` directory. if you want to see the main page for the version, the file is `./_preview/openshift-origin/latest/welcome/index.html`.
