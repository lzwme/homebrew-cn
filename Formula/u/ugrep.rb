class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://ghproxy.com/https://github.com/Genivia/ugrep/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "eaefcf39954626702503c22c436c2938ba5ca4ec74c569ea8c72e72e5ffb45fe"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "67fcc0d0d3db7760aeaf380ee6885381bb046a04d5bf60e0c718e9ec3fc68c33"
    sha256                               arm64_ventura:  "b31428e07e46fa2142115e4da3eed663797d36693996cea880ec230e60dc7e30"
    sha256                               arm64_monterey: "22bd289bccd64e0882dbe96fe07a70ee92ebb71d8a0322f1513bad07dc0b7503"
    sha256                               sonoma:         "edaa18a84f32b889c4135f5e6b06997b632a37e12f16fb8e618caf891cf7f5bc"
    sha256                               ventura:        "166485c293fff64a09a7df0a80497ce5562a8d6323c81006927e91a20ab0103d"
    sha256                               monterey:       "3257bd7d08f65b760996f3211530ac15980016971b60c2830e158ab4484a12e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0785f865e9d03b478b527e03022a5782c82639fb9986ef204b5c2abb5bf482d6"
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