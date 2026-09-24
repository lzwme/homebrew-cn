class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://ghfast.top/https://github.com/rrthomas/recode/releases/download/v3.7.16/recode-3.7.16.tar.gz"
  sha256 "c3d407f54f74bae76360312096e2ed46622f01c86e50b09ef45b2d93c8fcff2d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "917147916908fdf2d5c0d4ad0731ab7479887754d2bfdedd05e32375aa71d682"
    sha256 cellar: :any, arm64_tahoe:       "158a41a157d70a8031789fe97d21045777b7e8d72d93294ac57495f95fea3e00"
    sha256 cellar: :any, arm64_sequoia:     "77d2d3b854009d5748ee91a1c816b924f21a93cd5b77a7e962e38bd76430860c"
    sha256 cellar: :any, arm64_linux:       "71075130cf54fb270eb5ee316e296dadf7e602d79fe4fe6a935947f7d40b1888"
    sha256 cellar: :any, x86_64_linux:      "cbab97603dbba02f0c85c443b7581a770666c6ef3c7061926ff98196adca5ffd"
  end

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end