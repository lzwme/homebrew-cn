class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https:imgproxy.net"
  url "https:github.comimgproxyimgproxyarchiverefstagsv3.27.0.tar.gz"
  sha256 "2de751ce0a3e3d1b7c39ff7b3a75a4eb0d4be2f6e7e9c06890e10e93a912f65e"
  license "MIT"
  head "https:github.comimgproxyimgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cceaee11df8994d6653b28fccbee5dedb543e6b6cdf85a07786c1651d79295c2"
    sha256 cellar: :any,                 arm64_sonoma:  "76c1564fae0f8647b2e7046ad688af8a202fd36e15af62c320d26df893889f77"
    sha256 cellar: :any,                 arm64_ventura: "3c1ec53c1efe9167abef64141f466a1627bc65b15c6445305aa4ef4f6cf69c79"
    sha256 cellar: :any,                 sonoma:        "af595cf0b8afc32e678214e879d716581e8f4fd615fd5081a54a6a53d9ddb84c"
    sha256 cellar: :any,                 ventura:       "ca0d10b3d76240ccf6509365190240c7472d402b40407f6675ace6854cde34fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962d6f9c0307322e6b0a352d32cbabc9cc05bd0022521363e0277a893a45f6f9"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["CGO_LDFLAGS_ALLOW"] = "-s|-w"
    ENV["CGO_CFLAGS_ALLOW"] = "-Xpreprocessor"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin"imgproxy"
    sleep 20
    sleep 40 if OS.mac? && Hardware::CPU.intel?

    output = testpath"test-converted.png"
    url = "http:127.0.0.1:#{port}insecureresize:fit:100:100:trueplainlocal:test.jpg@png"

    system "curl", "-s", "-o", output, url
    assert_path_exists output

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end