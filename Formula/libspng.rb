class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://ghproxy.com/https://github.com/randy408/libspng/archive/v0.7.4.tar.gz"
  sha256 "47ec02be6c0a6323044600a9221b049f63e1953faf816903e7383d4dc4234487"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "75bd64679f3a4c3983c71dddde8346ed9e792f999e28fe8d5f3bf0b08b905e43"
    sha256 cellar: :any,                 arm64_monterey: "5379a4c948c514c3800c321df890d709ee4e6e0676c4efd786231507fc9ffeb2"
    sha256 cellar: :any,                 arm64_big_sur:  "ce086dec03a0d2fdb36c033db18393be5e789a0f8586594f624d39ddd263d9f7"
    sha256 cellar: :any,                 ventura:        "c76aaaf78c156d1ff0af19e0219c159a2da0e3134c3fb936057b566f6e10e9d5"
    sha256 cellar: :any,                 monterey:       "fdcbf11ea62d2dcbb6aaa56dd9f7f1b162c592de5a7301c09976ebb2113e217e"
    sha256 cellar: :any,                 big_sur:        "2f1bee0c91bf53b0289d067a93dfe45896f8f979914486c08e264571b82e2d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a77bbbc2800f350812338cb58d7a588f33fd2a7bac3eb0e2be6c7acfb3687f2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"

    output = shell_output("./example #{fixture}")
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\n" \
                 "compression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end