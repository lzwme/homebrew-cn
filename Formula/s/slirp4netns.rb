class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https://github.com/rootless-containers/slirp4netns"
  url "https://ghproxy.com/https://github.com/rootless-containers/slirp4netns/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "51aa240e1e29905ed35b449ca718539a01221aab3b6d291c4dc6777f0eb9d7d9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "29c43b0e18ad920c437b0a140a37fd02388be744c0a68860df3fc150bf4cb0b1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "bash" => :test
  depends_on "jq" => :test

  depends_on "glib"
  depends_on "libcap"
  depends_on "libseccomp"
  depends_on "libslirp"
  depends_on :linux

  resource "test-common" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.2.1/tests/common.sh"
    sha256 "756149863c2397c09fabbc0a3234858ad4a5b2fd1480fb4646c8fa9d294c001a"
  end

  resource "test-api-socket" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/rootless-containers/slirp4netns/v1.2.1/tests/test-slirp4netns-api-socket.sh"
    sha256 "075f43c98d9a848ab5966d515174b3c996deec8c290873d92e200dc6ceae1500"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("test-common").stage (testpath/"test")
    resource("test-api-socket").stage (testpath/"test")
    # The test secript requires network namespace to run, which is not available on Homebrew CI.
    # So here we check the error messages.
    output = shell_output("bash ./test/test-slirp4netns-api-socket.sh 2>&1", 1)
    assert_match "unshare: unshare failed: Operation not permitted", output
  end
end