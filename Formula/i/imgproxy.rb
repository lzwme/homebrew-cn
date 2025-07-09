class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.29.0.tar.gz"
  sha256 "8fcfb7e51b94fc732743e291646d656772089db90190289f91069b139f8291be"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "528e2895b682b73839f3d08cd21a79aeca723d50081eadf01ec82f54fb6dfad6"
    sha256 cellar: :any,                 arm64_sonoma:  "b1c1c1b58bbc59fb61e3d10bf85e25bb10d1a698b4f19b8150f5a3ff0264f8cc"
    sha256 cellar: :any,                 arm64_ventura: "2efaed5bc42a683671704c11f70452cd960738f0abd92334f1c0b1e80ae27fd6"
    sha256 cellar: :any,                 sonoma:        "3a9236d562ae609020059ee99c71923e2163d054fde3f5765c29782f35041303"
    sha256 cellar: :any,                 ventura:       "7f81245d1ae40368cebd6de5c4e96e27ab517a4ea619f0132595ae9aaf95d5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14f517152a32409fb4a16d1a36c587c87baf3850ccfd9cb3487c408c0dcac37"
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
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20
    sleep 50 if OS.mac? && Hardware::CPU.intel?

    output = testpath/"test-converted.png"
    url = "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"

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