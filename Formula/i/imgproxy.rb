class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "1bca6c09ac3a31734b3253f41da13c6ccddd5ebbc3aa2b5906d44a95a2a12734"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d643d05461b2bebb8ebc259c85463c468059ec914f64db43b980be753b9730a7"
    sha256 cellar: :any,                 arm64_sequoia: "dde89b7cf82141aa20040ce8788b0ba3c22ef16e0d25e10776f7fb07afa1ad03"
    sha256 cellar: :any,                 arm64_sonoma:  "da5da7ea1535e4dcbae6ab78bdbe55e328e23dbbce5e476bc9b2fde4ea5a4ecd"
    sha256 cellar: :any,                 sonoma:        "11eb48302c674186f198096c635a058a6e6991d6f1d2c160be51e2a156203e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079ad1123df35fa4b2377a9ca19245396beadffab14306eeb402372b01c261d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8180caaef69522f4162459960c1f48cc3aa5cc991bcdf13cd32e43a71e6df4bf"
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