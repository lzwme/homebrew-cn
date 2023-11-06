class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://ghproxy.com/https://github.com/Genivia/RE-flex/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "e08ed24a6799a6976f6e32312be1ee059b4b6b55f8af3b433a3016d63250c0e4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a2d60aa14d21ed5b8ed32d8a3e4cd77a027ac8de2f34a9e54d0c1b07cdd5b85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e570228f4adcffc834a24d86d727a0f0b240db98b9623994a2f2ee827cb834f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b56e7d92e872d371dfbd25e1affc0693dad16ef18201c18b4fed4624611347a"
    sha256 cellar: :any_skip_relocation, sonoma:         "42c508cb41f7d186f46abafd1b4ef796ed353942a43d88d262e161e262b43201"
    sha256 cellar: :any_skip_relocation, ventura:        "1ae912c11972dc2a0ba058e693a9842531b9dc87691b78de25e3495311235e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "469aa8ee8b520b29ef945e520bc7d539e33484c4911ff1fef9e796d216ab4418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9949ddd0ad5e7bc21c8c0f8b6ec97e1c127073cb0566821de7295101be07c95d"
  end

  depends_on "pcre2"

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
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end