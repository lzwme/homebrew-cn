class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "332a3b5fca782d41e424c210bec025d01682190228d62b807352c686073befde"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "1d7cf6aabe3f229dfdfd67d7e10d726dd8b4fcae3b29e05479c03997f7c12347"
    sha256                               arm64_ventura:  "7a6f338c5a4ee00623271559d180be2444f9a93e868f7f8aede79379f7c7f948"
    sha256                               arm64_monterey: "85821666f1610df80f59f8108d5443d89d3ae727ddddfa3eb53a67c92c256cc3"
    sha256                               sonoma:         "aeba1bb5b85a795ac947a88819f71d3757d68938ac94a9da19070af6a24edafe"
    sha256                               ventura:        "73ccd6ec89048fadf7b91284d172acf08d18a81673124dcad5001e4db94c8878"
    sha256                               monterey:       "f539babb2eacfca77af284eb990cb7774262e84581e18c93945cf55fe8627a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ef43bbce5f2a59ef81a72c1a7dc44fb8ec854dd3f669d4a393e71643c5651fd"
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