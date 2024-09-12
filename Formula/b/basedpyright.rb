class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.17.4.tgz"
  sha256 "454d809da7a04007fced9fbf092f9ff8bf3964c9a5516988411bd0327122afba"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3c599dc65fd3b1538d1970985bb6abaa03a039b7afe7d0a5700e479108aab65d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c599dc65fd3b1538d1970985bb6abaa03a039b7afe7d0a5700e479108aab65d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c599dc65fd3b1538d1970985bb6abaa03a039b7afe7d0a5700e479108aab65d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c599dc65fd3b1538d1970985bb6abaa03a039b7afe7d0a5700e479108aab65d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d188fc1301e5b0a0bef28687bb84f5c01c86011f8780fc987f099f2c07695750"
    sha256 cellar: :any_skip_relocation, ventura:        "d188fc1301e5b0a0bef28687bb84f5c01c86011f8780fc987f099f2c07695750"
    sha256 cellar: :any_skip_relocation, monterey:       "d188fc1301e5b0a0bef28687bb84f5c01c86011f8780fc987f099f2c07695750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c599dc65fd3b1538d1970985bb6abaa03a039b7afe7d0a5700e479108aab65d"
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