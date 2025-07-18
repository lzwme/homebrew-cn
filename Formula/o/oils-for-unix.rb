class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.34.0.tar.gz"
  sha256 "469018ef475a1ca9e8397c02f75b2dc63882a4a2e20d77a303d74a728ae31a22"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e597429c3a8c62f8146694750642df47c254f223aec253d25225e0df604f2fe"
    sha256 cellar: :any,                 arm64_sonoma:  "65cb120242cec4a7849696bc67f32ce5bd58289d18e9bd0cf497a7438f7cdc61"
    sha256 cellar: :any,                 arm64_ventura: "98decc2e2e19d48888f34b2790e5234782dd4df969f85a2c6ceb2ea766a65d7f"
    sha256 cellar: :any,                 sonoma:        "7f485aa1e32c88a5d2128870f9697924a8660d1707d2435bea6eb383ad962954"
    sha256 cellar: :any,                 ventura:       "e2ab59d3311aafd99d19fade3a746c91c73c61ef1e802e26039f1c6f30403dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca21426aec9f99dc293f49f3450ba56e7638206ede7ff4fa78eb7455e871571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76d16bc6a44b91f7a99fb22b76620a9692d836acd3f2cd557b1cb6056f242b3"
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