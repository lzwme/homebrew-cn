class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghproxy.com/https://github.com/Byron/dua-cli/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "e520bc22354afa8c6ef8e03c0bcf23d5c3cd9b3ace1632d443ff21799fd3ef45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceed2f6a577e2c1f43e50d79b9d00ffde4d039da4d1a1bf78c9cbba6772490a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2ce5ea688cfb6d690a89a16b21c5fe6d37f0a7f99cf1ca7b4e9901a6886d8fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a7de97731970a5c4e5441ad95a191038db6da18edf78583acd3f0642f353b7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6241c3372947b8a12dc505991cb7164b6c1aab593fcac8b255a66233ed9919ce"
    sha256 cellar: :any_skip_relocation, ventura:        "dc250d58ce36f73cc93b191160739eac513793c15066b9d8fedff37d80cbf2ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d1abbd8e98b3b5afa66e237fd533676ee0c0fdf84bf19211c0dcf8e3d2ba1890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36dedeae134f9888840246679715d420c0d09355e0505ed21efef00085abfb10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end