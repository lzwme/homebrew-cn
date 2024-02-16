require "languagenode"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.46.1.tgz"
  sha256 "ac55131153df206b558a0d4fad8f9c3588433fca24ad41bafd7cd8e9174d9ef0"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4b3d2fd1116c3918fcc34857ddbc55bcef307c06f99a3ff6bca2df1fa154004"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4b3d2fd1116c3918fcc34857ddbc55bcef307c06f99a3ff6bca2df1fa154004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b3d2fd1116c3918fcc34857ddbc55bcef307c06f99a3ff6bca2df1fa154004"
    sha256 cellar: :any_skip_relocation, sonoma:         "f07ffc208b3b550d8b5bf3dc66cdf76ebd40a000ee72b2aee83dae7ef3f71832"
    sha256 cellar: :any_skip_relocation, ventura:        "f07ffc208b3b550d8b5bf3dc66cdf76ebd40a000ee72b2aee83dae7ef3f71832"
    sha256 cellar: :any_skip_relocation, monterey:       "f07ffc208b3b550d8b5bf3dc66cdf76ebd40a000ee72b2aee83dae7ef3f71832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b3d2fd1116c3918fcc34857ddbc55bcef307c06f99a3ff6bca2df1fa154004"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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