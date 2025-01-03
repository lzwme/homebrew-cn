class Xmq < Formula
  desc "Tool and language to work with xmlhtmljson"
  homepage "https:libxmq.org"
  url "https:github.comlibxmqxmqarchiverefstags3.1.3.tar.gz"
  sha256 "f58dc5a1d3c523e19a9db24a7d14dd96e5307425950b0fefeae94d3c2ccc7339"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8907fab8d5f5257f80a3c66b4d10d206c24ff07d0527fc1b0b7af05e224bfcdb"
    sha256 cellar: :any,                 arm64_sonoma:  "0bcabe5e4befad3b0c2916cc5ecd190cbc2880468b1feb02947e7a172e5b4c12"
    sha256 cellar: :any,                 arm64_ventura: "d71bb6cc4ea57d9b25e0e6cac6344713aa93b562884d79ebeb47fd658c10d8fc"
    sha256 cellar: :any,                 sonoma:        "a82070e791e6f60e40997187fbf59622adf08b8775c0892de66877423e6817fa"
    sha256 cellar: :any,                 ventura:       "d2028f9304cac6f52a5c5f996f6fbe688d922602692fa1f52394b57a68a90138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d30ca868a68263d1d565c2a5ab71dafa9e606dfbd762629507033ee2685ad1"
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
    system "make", "install", "DESTDIR=#{prefix}"
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