class Xmq < Formula
  desc "Tool and language to work with xmlhtmljson"
  homepage "https:libxmq.org"
  url "https:github.comlibxmqxmqarchiverefstags3.2.1.tar.gz"
  sha256 "77916f6a59a1db3ada1c005eb7475d4009b4fe3323d659be79f2dc975d0330c1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9ef303e02a1bec43a96c79d7bd67e3a8f5832924f7c4a19a7c1dc47dda40744"
    sha256 cellar: :any,                 arm64_sonoma:  "17a56e365ae329c7b23c24ad1cdb0233bcc2af7aa59759477f8d961ec1abf967"
    sha256 cellar: :any,                 arm64_ventura: "d85d0dd7dbe843b2a194f075a9bf0d6a72ca08debd17fb549a0aa3a94382b517"
    sha256 cellar: :any,                 sonoma:        "c417cfeb854a821802d2c430b03e4e7de660ac73ed016fc5477aaa4894824cc0"
    sha256 cellar: :any,                 ventura:       "458aab78db413a9e090b8f7b65d142feae5819ea73ab1abf1e1d610071fe35bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b739abf70225b0903a5fce4bf31a325b1181b1db66f18765025a17fd0e9425b"
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