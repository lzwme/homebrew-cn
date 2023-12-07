class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghproxy.com/https://github.com/Byron/dua-cli/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "57909e05212e125faa5052e5dc5b9cc607bb909b7456ff08203055bf0ed2d8d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c71f688ac32cc79c41cf47ea9f2fe73539648cbe6912fcf130fd99d0df25e1a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f8a5b1532abb714ede25db806b3169ecb7bf7fae88c55ebc1473f83c311eb62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b982413a8d4586a589c558f4fa84780ab9665e916c5c2ae4b7d56b7e3c08392a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8b541b569ee44d172ba01c185512ce42296ca97d95a43fd11de4d52dff7eb91"
    sha256 cellar: :any_skip_relocation, ventura:        "dbe68bdf310708672e5186eb37b4b17ad90112fc2062ef6fb17968b9c1956f4e"
    sha256 cellar: :any_skip_relocation, monterey:       "a1367241f87569c13bd21ddc42b67ffda5dffe985913ad2786acb7eaae969b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba0f2169fc6ff076632743c40d53950d83538f86527ffd10e4fc9b5f9283a08"
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