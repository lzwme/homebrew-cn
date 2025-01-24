class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https:strace.io"
  url "https:github.comstracestracereleasesdownloadv6.13strace-6.13.tar.xz"
  sha256 "e209daf0ee038ca5adcc4c277e9273b4d51f46a2ff86da575d36742ac3508a17"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7ce2b2214ab4561587d4a0b6ef438cabc48e85f836a1b07425d353c2c073b264"
  end

  head do
    url "https:github.comstracestrace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "glibc"
  depends_on :linux
  depends_on "linux-headers@5.15"

  def install
    system ".bootstrap" if build.head?
    system ".configure", "--disable-silent-rules",
                          "--enable-mpers=no", # FIX: configure: error: Cannot enable m32 personality support
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end