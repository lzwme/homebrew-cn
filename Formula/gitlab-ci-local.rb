require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.41.1.tgz"
  sha256 "2261b5559a1d0caaa6e83f2e8658a35896a2078a2d68876e48498ce52202c81f"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81a5bc6fbd69233a4744785c36773d08e0f3f99570586115463862d6494f3690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81a5bc6fbd69233a4744785c36773d08e0f3f99570586115463862d6494f3690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81a5bc6fbd69233a4744785c36773d08e0f3f99570586115463862d6494f3690"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb6e2d1d2e6447d935833f65670ee063106ffb0f0d032f6fb6cfdd02f4ec71e"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb6e2d1d2e6447d935833f65670ee063106ffb0f0d032f6fb6cfdd02f4ec71e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb6e2d1d2e6447d935833f65670ee063106ffb0f0d032f6fb6cfdd02f4ec71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a5bc6fbd69233a4744785c36773d08e0f3f99570586115463862d6494f3690"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YML
      ---
      stages:
        - build
        - tag
      variables:
        HELLO: world
      build:
        stage: build
        needs: []
        tags:
          - shared-docker
        script:
          - echo "HELLO"
      tag-docker-image:
        stage: tag
        needs: [ build ]
        tags:
          - shared-docker
        script:
          - echo $HELLO
    YML

    system "git", "init"
    system "git", "add", ".gitlab-ci.yml"
    system "git", "commit", "-m", "'some message'"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    rm ".git/config"

    (testpath/".git/config").write <<~EOS
      [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
      [remote "origin"]
        url = git@github.com:firecow/gitlab-ci-local.git
        fetch = +refs/heads/*:refs/remotes/origin/*
      [branch "master"]
        remote = origin
        merge = refs/heads/master
    EOS

    assert_match(/name\s*?description\s*?stage\s*?when\s*?allow_failure\s*?needs\n/,
        shell_output("#{bin}/gitlab-ci-local --list"))
  end
end