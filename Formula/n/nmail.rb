class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://ghfast.top/https://github.com/d99kris/nmail/archive/refs/tags/v5.10.3.tar.gz"
  sha256 "a667b410a865eef7fb08ca9afceebf6a9a85c61850df875005255a88960c5158"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e9d07e160b98ddd1f0bbc113de3b91460ed9515754ed07d80777bf46592507d"
    sha256 cellar: :any,                 arm64_sequoia: "e182f0e1323992af8ddc83fd5dac87565d29d454de9200a3b36f584eab7ade07"
    sha256 cellar: :any,                 arm64_sonoma:  "4636c97fafd045eef26b33f72a3a22406f4fd53c5f32b72148d6c8f4d6dfdb2d"
    sha256 cellar: :any,                 sonoma:        "1923bcc5a6e28f585f4c23f158415865e9b49ce970423fd16a4104d734d7dc96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edc6b2f46d42887d69bd9566b022ccf4548d664cb932844ac354d53b3aad0fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a755e09c43cc399166abfcc3993840c0fb064244d2444c53c2b5605e3a227d"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "xapian"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def install
    args = []
    # Workaround to use uuid from Xcode CLT
    args << "-DLIBUUID_LIBRARIES=System" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".nmail/main.conf").write "user = test"
    output = shell_output("#{bin}/nmail --confdir #{testpath}/.nmail 2>&1", 1)
    assert_match "error: imaphost not specified in config file", output

    assert_match version.to_s, shell_output("#{bin}/nmail --version")
  end
end