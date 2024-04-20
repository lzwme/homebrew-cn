require "languagenode"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.48.1.tgz"
  sha256 "1176deb0cc5e0a17a504e0260ae874c4e3681384361359000b61fe3fe595ef37"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc8ab40b8946b920377d36672bf4f185d7fe799b320aaa17cfad4500e6019dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc8ab40b8946b920377d36672bf4f185d7fe799b320aaa17cfad4500e6019dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc8ab40b8946b920377d36672bf4f185d7fe799b320aaa17cfad4500e6019dfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d144db52f116a8ac9ae6785e300683843b841b9ba849161169d588c39ccb087"
    sha256 cellar: :any_skip_relocation, ventura:        "8d144db52f116a8ac9ae6785e300683843b841b9ba849161169d588c39ccb087"
    sha256 cellar: :any_skip_relocation, monterey:       "8d144db52f116a8ac9ae6785e300683843b841b9ba849161169d588c39ccb087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8ab40b8946b920377d36672bf4f185d7fe799b320aaa17cfad4500e6019dfc"
  end

  depends_on "node"

  # add missing schema.json file
  # upstream bug report, https:github.comfirecowgitlab-ci-localissues1190
  resource "schema.json" do
    url "https:raw.githubusercontent.comfirecowgitlab-ci-localmastersrcschemaschema.json"
    sha256 "81578fbb5a57ed922c66135c3bd5ddc0791ba3478c7bd64142997f6d3c5bd53c"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    (libexec"libnode_modulesgitlab-ci-localsrcschema").install resource("schema.json")
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