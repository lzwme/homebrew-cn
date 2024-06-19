require "languagenode"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.51.0.tgz"
  sha256 "1c6fe311ef965b8ab99d4e44a8b700c3a4c8d45197facbf545b72ea45dd14a84"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a91d96a4e569fb83d48694b1a1ceacc0cbab69eb13cd68d0ab30374f49bcded7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a91d96a4e569fb83d48694b1a1ceacc0cbab69eb13cd68d0ab30374f49bcded7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a91d96a4e569fb83d48694b1a1ceacc0cbab69eb13cd68d0ab30374f49bcded7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf48b7cc51844940d786bb521078cfa679f398024ed998aee9b1d6542950fb62"
    sha256 cellar: :any_skip_relocation, ventura:        "bf48b7cc51844940d786bb521078cfa679f398024ed998aee9b1d6542950fb62"
    sha256 cellar: :any_skip_relocation, monterey:       "bf48b7cc51844940d786bb521078cfa679f398024ed998aee9b1d6542950fb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918857b7f5c4e3418a444780c8a3783a54e4f21322367817eb7063f50f9964cc"
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