class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.53.0.tgz"
  sha256 "384358e3ca8b37f07412ad8ba0fefc0ac1fbccee4dc07bf7a82357bd8c76b1f0"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5d95b55dec574950c68c22848013d0106514015689aa3f393a958a175d015147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bc75dda03b0a6e43ab9b26236a3373e86c2cf9453309d262fcbf47ad8b81178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bc75dda03b0a6e43ab9b26236a3373e86c2cf9453309d262fcbf47ad8b81178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc75dda03b0a6e43ab9b26236a3373e86c2cf9453309d262fcbf47ad8b81178"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7509352eb510578f995fe539fd183155f1e4b8027b5daaf35b877aa11ea5563"
    sha256 cellar: :any_skip_relocation, ventura:        "b7509352eb510578f995fe539fd183155f1e4b8027b5daaf35b877aa11ea5563"
    sha256 cellar: :any_skip_relocation, monterey:       "b7509352eb510578f995fe539fd183155f1e4b8027b5daaf35b877aa11ea5563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc75dda03b0a6e43ab9b26236a3373e86c2cf9453309d262fcbf47ad8b81178"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath".gitlab-ci.yml").write <<~YML
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