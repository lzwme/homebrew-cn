require "languagenode"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.46.0.tgz"
  sha256 "8af794d105182e3d8e7b96a43776d504a357e7e40e07eb49c9c6fe12b79bdf61"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f0be6e385f485c7f38fb86c0e8d062fa29522cb282beabe58e1ebca5d898a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f0be6e385f485c7f38fb86c0e8d062fa29522cb282beabe58e1ebca5d898a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f0be6e385f485c7f38fb86c0e8d062fa29522cb282beabe58e1ebca5d898a32"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b2d78e0fd3ffb7bd904bd36e7c346163081ce2050d4998ee3a21e41a02d2ce"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b2d78e0fd3ffb7bd904bd36e7c346163081ce2050d4998ee3a21e41a02d2ce"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b2d78e0fd3ffb7bd904bd36e7c346163081ce2050d4998ee3a21e41a02d2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f0be6e385f485c7f38fb86c0e8d062fa29522cb282beabe58e1ebca5d898a32"
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