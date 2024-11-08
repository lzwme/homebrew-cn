class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https:www.micropython.org"
  url "https:github.commicropythonmicropythonreleasesdownloadv1.24.0micropython-1.24.0.tar.xz"
  sha256 "cde2a6795280945100089c053ba85f842d85f3038229d743da35a3673bc1786b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ee316369a7cb78751f94e01e7998763b2331af864a28070f34fec0e89a2ad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39f5db5d86d837a19161c93070911e9aee5bdee970f92cd7a4ed1a6a64d3fbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b67ffae89e9c8f5007e21b4694fa1feb587997112c72a6dad729640cab2c82e"
    sha256 cellar: :any_skip_relocation, sonoma:        "613962ca2e0f6074dc76ddcfa09c8c28f89539d74b2fc8089ce5c03c7fc60daf"
    sha256 cellar: :any_skip_relocation, ventura:       "3ee8a08bac9b3226d63495447463586ad6da48da132b3912a4c467de7d79e96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae330d48509fb62a44b8a51c5e1f2d42d45cedd897b45fdaefd251bf1041167"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python" # Requires libffi v3 closure API

  def install
    system "make", "-C", "portsunix", "install", "PREFIX=#{prefix}"
    bin.install "mpy-crossbuildmpy-cross"
  end

  test do
    lib_version = "6" if OS.linux?

    # Test the FFI module
    (testpath"ffi-hello.py").write <<~PYTHON
      import ffi

      libc = ffi.open("#{shared_library("libc", lib_version)}")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    PYTHON

    system bin"mpy-cross", "ffi-hello.py"
    system bin"micropython", "ffi-hello.py"
  end
end