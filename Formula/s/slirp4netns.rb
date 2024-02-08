class Slirp4netns < Formula
  desc "User-mode networking for unprivileged network namespaces"
  homepage "https:github.comrootless-containersslirp4netns"
  url "https:github.comrootless-containersslirp4netnsarchiverefstagsv1.2.3.tar.gz"
  sha256 "acce648fab8fe5f113c41a8fd6d20177708519b4ddaa60f845e1998a17b22ca5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10df4d3c42b1a4103f7f57617a307dee2d9f7f2815a5a6a0191adf043a755912"
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

  def install
    system ".autogen.sh"
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-test-common" do
      url "https:raw.githubusercontent.comrootless-containersslirp4netnsv1.2.1testscommon.sh"
      sha256 "756149863c2397c09fabbc0a3234858ad4a5b2fd1480fb4646c8fa9d294c001a"
    end

    resource "homebrew-test-api-socket" do
      url "https:raw.githubusercontent.comrootless-containersslirp4netnsv1.2.1teststest-slirp4netns-api-socket.sh"
      sha256 "075f43c98d9a848ab5966d515174b3c996deec8c290873d92e200dc6ceae1500"
    end

    resource("homebrew-test-common").stage (testpath"test")
    resource("homebrew-test-api-socket").stage (testpath"test")
    # The test secript requires network namespace to run, which is not available on Homebrew CI.
    # So here we check the error messages.
    output = shell_output("bash .testtest-slirp4netns-api-socket.sh 2>&1", 1)
    assert_match "unshare: unshare failed: Operation not permitted", output
  end
end