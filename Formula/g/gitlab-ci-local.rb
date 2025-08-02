class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https://github.com/firecow/gitlab-ci-local"
  url "https://registry.npmjs.org/gitlab-ci-local/-/gitlab-ci-local-4.61.1.tgz"
  sha256 "de6dbb860a9436f7513132553db13f835cf9be54333df8f753cce570cb0c316d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8084f04e60648bb6a339dab900e7628051c66ca660f5ec6f10c023e4e559796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8084f04e60648bb6a339dab900e7628051c66ca660f5ec6f10c023e4e559796"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8084f04e60648bb6a339dab900e7628051c66ca660f5ec6f10c023e4e559796"
    sha256 cellar: :any_skip_relocation, sonoma:        "168cb0a011545f357ff0ababa2c72dee2dd1d28ff6874a6a0b5e34a3dedf1535"
    sha256 cellar: :any_skip_relocation, ventura:       "168cb0a011545f357ff0ababa2c72dee2dd1d28ff6874a6a0b5e34a3dedf1535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8084f04e60648bb6a339dab900e7628051c66ca660f5ec6f10c023e4e559796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8084f04e60648bb6a339dab900e7628051c66ca660f5ec6f10c023e4e559796"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YAML
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
    YAML

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