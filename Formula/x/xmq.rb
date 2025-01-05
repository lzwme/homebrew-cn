class Xmq < Formula
  desc "Tool and language to work with xmlhtmljson"
  homepage "https:libxmq.org"
  url "https:github.comlibxmqxmqarchiverefstags3.2.0.tar.gz"
  sha256 "d49ea8e3d646fe2c9fe7c50ecab6943f67c55c6b589af469af99f1220521b9d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "531a06c7277af3ae405982945abf9d22484ba7d5c18948aeb6d7d9a2fe5878cf"
    sha256 cellar: :any,                 arm64_sonoma:  "6911f9d2d110060c85f876357d13be734deb187b85e50c9060512a9143054294"
    sha256 cellar: :any,                 arm64_ventura: "1637573624991929180856259783d5b9eb665b8be846d4c1de0d4d8cf7b37134"
    sha256 cellar: :any,                 sonoma:        "21a5a573b81f4604c03afbfdd0a2598348f8d568c3999c5c9ff54d42380490ae"
    sha256 cellar: :any,                 ventura:       "ad89b4482781b7b7f7999feca0c89980c790eba04360344e38986ad4fbf7b241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e880c815299b3736864aa482ffb98940ca9465e54266e4537ec74e6e637264f"
  end

  head do
    url "https:github.comlibxmqxmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.xml").write <<~XML
      <root>
      <child>Hello Homebrew!<child>
      <root>
    XML
    output = shell_output("#{bin}xmq test.xml select child")
    assert_match "Hello Homebrew!", output
  end
end