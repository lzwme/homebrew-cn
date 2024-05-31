require "languagenode"

class GitlabCiLocal < Formula
  desc "Run gitlab pipelines locally as shell executor or docker executor"
  homepage "https:github.comfirecowgitlab-ci-local"
  url "https:registry.npmjs.orggitlab-ci-local-gitlab-ci-local-4.50.0.tgz"
  sha256 "954c96f24f5751c9f88ef322d3fc6aff2bba21fc99086bb3c0c55702217110c2"
  license "MIT"
  head "https:github.comfirecowgitlab-ci-local.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eab80dddceab070251798838843f9c5f7b0a970812cd7abb6531a7109b9e8f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eab80dddceab070251798838843f9c5f7b0a970812cd7abb6531a7109b9e8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eab80dddceab070251798838843f9c5f7b0a970812cd7abb6531a7109b9e8f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0cadb21dc43e8fea163549eee44b13ade432995eb6bfd81181417c54283688c"
    sha256 cellar: :any_skip_relocation, ventura:        "b0cadb21dc43e8fea163549eee44b13ade432995eb6bfd81181417c54283688c"
    sha256 cellar: :any_skip_relocation, monterey:       "b0cadb21dc43e8fea163549eee44b13ade432995eb6bfd81181417c54283688c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a386ace3fd2985b9d006142a24a2b6c831874db2e94787f751344b12fffcc5ce"
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