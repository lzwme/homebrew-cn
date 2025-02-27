class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.28.0.tgz"
  sha256 "dfd63eb31ed0bd330964839255c60c218ee9a82b3e5a9a3141d073d6a8d30034"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eeb85769d1cebb0d34563116d7b3e1abf6d1d02f4a38952f9a6e1e531a2e7db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eeb85769d1cebb0d34563116d7b3e1abf6d1d02f4a38952f9a6e1e531a2e7db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7eeb85769d1cebb0d34563116d7b3e1abf6d1d02f4a38952f9a6e1e531a2e7db"
    sha256 cellar: :any_skip_relocation, sonoma:        "c263b07b5170c13cb4763feffe3a46f2305c76562358343505e4aa320b909ec7"
    sha256 cellar: :any_skip_relocation, ventura:       "c263b07b5170c13cb4763feffe3a46f2305c76562358343505e4aa320b909ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eeb85769d1cebb0d34563116d7b3e1abf6d1d02f4a38952f9a6e1e531a2e7db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end