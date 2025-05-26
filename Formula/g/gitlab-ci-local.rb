class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.60.0.tgz"
  sha256 "15daec3b5fd57353c3d6e2a334d13f8fe2624d2da118928e0bc96a1060d7ba32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117c1a898f2ea93631a1efd156572d0cf0c0c818b888db4086a08246fb0b4b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "117c1a898f2ea93631a1efd156572d0cf0c0c818b888db4086a08246fb0b4b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "117c1a898f2ea93631a1efd156572d0cf0c0c818b888db4086a08246fb0b4b00"
    sha256 cellar: :any_skip_relocation, sonoma:        "0120a291a6b156fb627017052818beb2298755578bff54161d9bf3b070a2c021"
    sha256 cellar: :any_skip_relocation, ventura:       "0120a291a6b156fb627017052818beb2298755578bff54161d9bf3b070a2c021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afcf353556e703d9e21d2c77d8368084da470282dea0f327505952ba44e56474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd637b080caabebbea777983525b3aa5d4cd05700eb63e4ffa2d699fe6a09008"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath".gitlab-ci.yml").write <<~YAML
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
    rm ".gitconfig"

    (testpath".gitconfig").write <<~EOS
      [core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
        ignorecase = true
        precomposeunicode = true
      [remote "origin"]
        url = git@github.com:firecowgitlab-ci-local.git
        fetch = +refsheads*:refsremotesorigin*
      [branch "master"]
        remote = origin
        merge = refsheadsmaster
    EOS

    assert_match(name\s*?description\s*?stage\s*?when\s*?allow_failure\s*?needs\n,
        shell_output("#{bin}gitlab-ci-local --list"))
  end
end