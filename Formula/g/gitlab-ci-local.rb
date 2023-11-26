require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.45.2.tgz"
  sha256 "a68ffa13f1e46dc92e9eac0012f3042fb7205762fe58fad5c645ef0379a4e8e5"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6db9ba335c4a64245ee21cf9251c21ac54fc4b57b643d58026c33fb31609481d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6db9ba335c4a64245ee21cf9251c21ac54fc4b57b643d58026c33fb31609481d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6db9ba335c4a64245ee21cf9251c21ac54fc4b57b643d58026c33fb31609481d"
    sha256 cellar: :any_skip_relocation, sonoma:         "320061ab166f172b5adce3b7e119b6eb45da4578daccca967a2a2db52b47405f"
    sha256 cellar: :any_skip_relocation, ventura:        "320061ab166f172b5adce3b7e119b6eb45da4578daccca967a2a2db52b47405f"
    sha256 cellar: :any_skip_relocation, monterey:       "320061ab166f172b5adce3b7e119b6eb45da4578daccca967a2a2db52b47405f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db9ba335c4a64245ee21cf9251c21ac54fc4b57b643d58026c33fb31609481d"
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