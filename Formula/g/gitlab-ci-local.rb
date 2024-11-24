class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.56.0.tgz"
  sha256 "1357c078a398103d89fbbd78ed49d04eabf8fa7489ab58c30bf8ff6621deb742"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "c336815d3921af3e2bad71a7b849df052b171e7014680d3413bb2c40ca69a57e"
    sha256                               arm64_sonoma:  "1448400239137cd6ca238f1364b96a2f87323321c8ee9ec1e00eb80852e23291"
    sha256                               arm64_ventura: "a903963fccdc1bcc00b90be109b925d2707ec3c4401e1bedd8e3b14a62727e48"
    sha256                               sonoma:        "325c9f8d54d6a148746c5f193b86a4f695cb31155aa049369b92854012bf1f7d"
    sha256                               ventura:       "4d5410c9422ef5216c344c3500ec8b562114f0dd7a1d4661231ad2cc2615480a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efd4e4f488f61af03b9bf403d4e67f1feb4de2c291a05f2d93da4cb75fc46e21"
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