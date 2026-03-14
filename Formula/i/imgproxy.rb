class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.31.0.tar.gz"
  sha256 "862fd7716a172e91b534d462f3bf3b5b1dc6cac4d4790ce4e9c7faafc79822f4"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76e0cdbba0d378ae0118cbb6daaa17e05101ce6597bab2e8af55d4f261ddab18"
    sha256 cellar: :any,                 arm64_sequoia: "8840c03d6875fc91d76dcc6d463bc16f9b566506c6969cf6b6200d5062d03829"
    sha256 cellar: :any,                 arm64_sonoma:  "d49ec782f9fa0407444d37d7faa6dd3b251ddfc087a897ad6b4e82343508d638"
    sha256 cellar: :any,                 sonoma:        "f33dc38f3f590b338f15030dc09217d8b2b7a210a13b9e34802386f9ef7424a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b69deb70e71ad76fd1e04f6736ea9e5470ce68de4b311496ad898b679a41bc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa6129c5779d3ad2502b22ba6dca0c00cae5b30a8ac7d81723dfa5cef16dc79"
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