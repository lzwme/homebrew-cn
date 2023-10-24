require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.45.0.tgz"
  sha256 "5ac251ad69a6c26a338b3063b6c2732292d14fe88e5b3877f4dcf6b1578eca92"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ac92113cf1987190a89bc757b6207807ba72e65600f6940cf52eed2ddcd2101"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ac92113cf1987190a89bc757b6207807ba72e65600f6940cf52eed2ddcd2101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ac92113cf1987190a89bc757b6207807ba72e65600f6940cf52eed2ddcd2101"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f6e04258fe7cff405034f505bdb125fb16e9a192919b5c2ef5ec82a86746f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f6e04258fe7cff405034f505bdb125fb16e9a192919b5c2ef5ec82a86746f5c"
    sha256 cellar: :any_skip_relocation, monterey:       "8f6e04258fe7cff405034f505bdb125fb16e9a192919b5c2ef5ec82a86746f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac92113cf1987190a89bc757b6207807ba72e65600f6940cf52eed2ddcd2101"
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