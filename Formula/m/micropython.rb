class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://ghfast.top/https://github.com/micropython/micropython/releases/download/v1.26.0/micropython-1.26.0.tar.xz"
  sha256 "a1b8e0f6bf7a8a78b55ac865c46c4c45f9623a86a1785d2063ff1cb3b6e661d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df6fc28eb7c271612a7ae06a929efa487c5cbda642f1b0802210153f56a4a6f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c53b91a15b1ce1984c668da550c849616a8e2924af26e5e2fc1689cb540268b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19e2d9b648b60081b66e6f2a3ba99d4c034f71b456d5e669bd3a9594b8656ecb"
    sha256 cellar: :any_skip_relocation, tahoe:         "6f9001d0f8d46574a7a24bb50288ec59b6731efd39e727c6c59b73479fb3ba0c"
    sha256 cellar: :any_skip_relocation, sequoia:       "a33b0b1e4d7f464185db49ddd1d58746c303a5f645b5a1c716854928138ed95c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b6a6a6686514b773787871eab3306dcc31342d6a5fc15bf47206a56c3385a23"
    sha256 cellar: :any_skip_relocation, ventura:       "d203f50da1f48cf6be08ab09fdb66f6f36ccf896bdecf00f475bb8c9e6bb62f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e11a276d98b7cbb529a82a6c143a564b70e3050f12bdd17ef3f5bb7277683c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768d71065f1b0fcd878b73d3eedb759a850aaa1f99b1b8beddc510fa84e2417b"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python" # Requires libffi v3 closure API

  def install
    system "make", "-C", "ports/unix", "install", "PREFIX=#{prefix}"
    bin.install "mpy-cross/build/mpy-cross"
  end

  test do
    lib_version = "6" if OS.linux?

    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~PYTHON
      import ffi

      libc = ffi.open("#{shared_library("libc", lib_version)}")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    PYTHON

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end