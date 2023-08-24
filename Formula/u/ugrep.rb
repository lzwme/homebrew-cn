class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/v4.0.2.tar.gz"
  sha256 "5230e472bb28ecbc0a7c3046559a5e9504de0135f58ac6faefeef75873772a46"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "bee78f02f71c116e8232f0449aa05e0953167afbde8fd0fcf5e35b0055eb4105"
    sha256                               arm64_monterey: "ac7bd76635bb8a157134843bcd63801edbf9aa8bbe7aab85ccc5b0e838edf993"
    sha256                               arm64_big_sur:  "e7ed233940f0823c6b424ea693a4567e6c713f053827a46666eb88d2443d844f"
    sha256                               ventura:        "bd0f5004b54eb585f3e9b3c55b86293bab082d8c5bb95b2c51792e9854d56a43"
    sha256                               monterey:       "1f805350003ad4889b31d0216b9c7dde748e646a458f47e90bbfa7179eab067a"
    sha256                               big_sur:        "3e8e13325543a27a7ce1605d257f7ecaadc35544d26f1deb114bf745e5d40118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7dcde7baf9ea042207601001bb964cfdc22c8a33ff7ee6c8ec148e144c86bbe"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end