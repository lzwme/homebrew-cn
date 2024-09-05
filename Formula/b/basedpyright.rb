class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.17.2.tgz"
  sha256 "b25f4b2f23276d99aad6c165776c9ceaa5d06b80bf9688aa29953f7e9dc19048"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c438af49842fdb17d81240e3ba480ad83be7316396eeee5edf482b4e40d6d9df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c438af49842fdb17d81240e3ba480ad83be7316396eeee5edf482b4e40d6d9df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c438af49842fdb17d81240e3ba480ad83be7316396eeee5edf482b4e40d6d9df"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f7238b5b0af695b513033a320a5385be9bf1301f115f45c351f0474e9b42e72"
    sha256 cellar: :any_skip_relocation, ventura:        "7f7238b5b0af695b513033a320a5385be9bf1301f115f45c351f0474e9b42e72"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7238b5b0af695b513033a320a5385be9bf1301f115f45c351f0474e9b42e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c438af49842fdb17d81240e3ba480ad83be7316396eeee5edf482b4e40d6d9df"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end