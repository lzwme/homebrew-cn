require "languagenode"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.52.2.tgz"
  sha256 "c604bd7659ebffe8f5fd6ae90545f882b93bc6cededeb102167fbe72fe7d0950"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4ca7350ca019c4490155de25d84c6d9623b5bf668e06ad68c4738e49a6abdfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ca7350ca019c4490155de25d84c6d9623b5bf668e06ad68c4738e49a6abdfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4ca7350ca019c4490155de25d84c6d9623b5bf668e06ad68c4738e49a6abdfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cc0acbcbac5d98832403b367fb0ee653f232f130469007b5a5efcb54baafad8"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc0acbcbac5d98832403b367fb0ee653f232f130469007b5a5efcb54baafad8"
    sha256 cellar: :any_skip_relocation, monterey:       "8cc0acbcbac5d98832403b367fb0ee653f232f130469007b5a5efcb54baafad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c08d491bfbf997a79f2d1a754742adb64304d2816d4eafb59e2769caf3a857d8"
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