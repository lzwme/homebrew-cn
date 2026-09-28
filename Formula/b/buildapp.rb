class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://ghfast.top/https://github.com/xach/buildapp/archive/refs/tags/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 7
  head "https://github.com/xach/buildapp.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "8435a59794f227580382988ec4946041f049b6731156cbe700ac9a7bf0b82b9f"
    sha256               arm64_tahoe:       "578b30654fe7a53f2c2bd6f1e4395dec89c78912e6c99bc32dde192c7970088e"
    sha256               arm64_sequoia:     "30c5575e0c63dae18c48fa59e5adebbb7f9bcb6e995f51f3b63d1c7c90032894"
    sha256 cellar: :any, arm64_linux:       "3feaf33a8d3db5205e9fc9d2463376adb2a947c759b7ffda895284bb0c481704"
    sha256 cellar: :any, x86_64_linux:      "824e3772824bed5563703a8c815a71c42f9df4f621a32ce3c6102687d5607bb9"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"

    # Work around patchelf corrupting the SBCL core which is appended to binary
    # TODO: Find a better way to handle this in brew, either automatically or via DSL
    if OS.linux? && build.bottle?
      cp bin/"buildapp", prefix
      Utils::Gzip.compress(prefix/"buildapp")
    end
  end

  post_install_steps do
    install_gzipped_executable "buildapp.gz", "bin/buildapp"
  end

  test do
    code = <<~LISP
      (defun f (a) (declare (ignore a)) (write-line "Hello, homebrew"))
    LISP
    system bin/"buildapp", "--eval", code, "--entry", "f", "--output", "t"
    assert_equal "Hello, homebrew\n", shell_output("./t")
  end
end