require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.41.0.tgz"
  sha256 "a6161277dacb888cc35bd7941d9403fedbf8917234f6eded7ca00aa48b13e5aa"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f42c5c0e3b40f8029ad7f1d5a188891cbe5f437b6af675fe7f52be735a764e6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42c5c0e3b40f8029ad7f1d5a188891cbe5f437b6af675fe7f52be735a764e6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f42c5c0e3b40f8029ad7f1d5a188891cbe5f437b6af675fe7f52be735a764e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd2b9180317c15913d009b8b33c0f0f6667484f05cf4c6dc181eacfcf742601"
    sha256 cellar: :any_skip_relocation, monterey:       "5fd2b9180317c15913d009b8b33c0f0f6667484f05cf4c6dc181eacfcf742601"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fd2b9180317c15913d009b8b33c0f0f6667484f05cf4c6dc181eacfcf742601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f42c5c0e3b40f8029ad7f1d5a188891cbe5f437b6af675fe7f52be735a764e6c"
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