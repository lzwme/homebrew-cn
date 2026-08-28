class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://ghfast.top/https://github.com/Genivia/RE-flex/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "33b78f217f9734697940c5003cc55a0ad92747674f357008602816a2080139df"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c033335cef2205b4bcb31efa08d2cace88402c46e1293a596dcdf2f99c33bc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca936f6e71ea21879956a869275b171f5b482e3d397cb555e2810ac3fb2e0db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cec441186d95113187d82e3a487921b65d0782725e9b79f77aef70d3988b41b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f16149dae9140ed509249588f7f418c3f5d48fcfe81fa59bb3d82815ecbd1566"
    sha256 cellar: :any,                 arm64_linux:   "12ece5f219ddd3c8969d4ba6579b5856b4f66eb3398061b45bc7752ba76147f7"
    sha256 cellar: :any,                 x86_64_linux:  "580f93220b2eb5bdc9a9f2d5099692d1d785b520641ad88a050cdbaaf37ebfa7"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~EOS
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system bin/"reflex", "--flex", "echo.l"
    assert_path_exists testpath/"lex.yy.cpp"
  end
end