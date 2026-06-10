class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "c93f149505d604f28df3bffcdb9cab9aa64f03228357bdf2cadb435eb9acf645"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c0f97b5d67af26bad5e047b0b81c7b8fc9cd8497cc7494ef7ec72884f0d6e0e"
    sha256 cellar: :any, arm64_sequoia: "6d2c4f1a3245a04cc3fe86aeda35ee3cf481eea4d579d209010ac28d3992488d"
    sha256 cellar: :any, arm64_sonoma:  "abb90420ff37db7e64ee1f93e9c3395e367d681593b97a7fbce9a4ccbe0a3207"
    sha256 cellar: :any, sonoma:        "a0b27706abbb8d35ada08537bd7588126f7dc9f91d73a3bcc0a389f3d6faba5f"
    sha256 cellar: :any, arm64_linux:   "dfbd01fe50e8d0543999fd03d0ec8b593d61fa9f75854174bdaaf865a47b12c4"
    sha256 cellar: :any, x86_64_linux:  "f289559855257b075f90141f068fdfa3aeff8050689016d6258273e288cd6f0d"
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

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
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