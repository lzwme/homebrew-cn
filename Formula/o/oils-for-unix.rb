class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.30.0.tar.gz"
  sha256 "d1d79dd41d0775b376184e6cd4cf8a1ea369aa9d9383abcc7d96725e2ffb82f2"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3064d0878d1d117ab2db4f54e3444371047d2348915cb8741cfe122259e8ef0d"
    sha256 cellar: :any,                 arm64_sonoma:  "de2fe5f8196dbe80e70228be83d2a2652b5aa47ec5f9b21bfec4a53ddca3b2c9"
    sha256 cellar: :any,                 arm64_ventura: "93356216af355139e0fa5178848b73bd878fae8ef0cbb1d7ee7e36971cdd3b77"
    sha256 cellar: :any,                 sonoma:        "6884c51b1832e143640b94cb22e6320021bee39566d0194e56dd5344f7f30f23"
    sha256 cellar: :any,                 ventura:       "88d183e6e4117abd05e0834103f1eb20d9c10d39720e40588dc32a3e26c83db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14c6f57b7ad130793619bf81a20eeb9cf399b21fbd1be9df7dbc1c3f99943705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "445cba301a0795546a26be93cbee4b21746b241e6ae86e1971d14f3e02bdf425"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end