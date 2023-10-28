require "language/node"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.45.1.tgz"
  sha256 "a51b212f7d65d6d6a12f9c736b1ee5a5122dfa6e7639460f16a22e7959a8a799"
  license "MIT"
  head "https://github.com/firecow/gitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fadfdfff789ce19b36b75980da6c22b51f2bda421137d0b86aabaf8473e0fd4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fadfdfff789ce19b36b75980da6c22b51f2bda421137d0b86aabaf8473e0fd4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fadfdfff789ce19b36b75980da6c22b51f2bda421137d0b86aabaf8473e0fd4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e38a04f5baa6bbbbedd186045586403a2bf73ceebd84a123097ecf789561410"
    sha256 cellar: :any_skip_relocation, ventura:        "8e38a04f5baa6bbbbedd186045586403a2bf73ceebd84a123097ecf789561410"
    sha256 cellar: :any_skip_relocation, monterey:       "8e38a04f5baa6bbbbedd186045586403a2bf73ceebd84a123097ecf789561410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fadfdfff789ce19b36b75980da6c22b51f2bda421137d0b86aabaf8473e0fd4f"
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