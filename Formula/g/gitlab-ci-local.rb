class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.60.1.tgz"
  sha256 "2945d0322fd00ab9b734c6bda95a23b29162a906048ca8bda394466cb75a2f68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5eaf32f97b932b85a301bdb798b82904eea4cbb3bed3b4423ac4ec14cef7b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5eaf32f97b932b85a301bdb798b82904eea4cbb3bed3b4423ac4ec14cef7b82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5eaf32f97b932b85a301bdb798b82904eea4cbb3bed3b4423ac4ec14cef7b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a191bfce691767a4f72b10ad9236432427810f1f2abe71ca359d6760c3c242c"
    sha256 cellar: :any_skip_relocation, ventura:       "2a191bfce691767a4f72b10ad9236432427810f1f2abe71ca359d6760c3c242c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9e045efe09080870a4059fa1ad2193a10d9d8b891e44bd78452ee7cc9c8ae9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770f39d23e2c4e5f32182511f9dc01b13ed174c82ec28d13f7e4f8a69ff64678"
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