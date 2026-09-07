class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.14.tar.gz"
  sha256 "627da6de11f632f5acb95753ca5aa739f45c3730eb8f7432cf1a9ac92a8b4b92"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aca3f42536ed2270d50919bfffb7deb1b45b0fc19409decaf76e68aec6152b90"
    sha256 cellar: :any, arm64_sequoia: "657a33be6f2f1da8b990616a6c59a7f1db3f5d68a43cff9b61bf13705cca45e7"
    sha256 cellar: :any, arm64_sonoma:  "fd78c7f8f1d0687bef9b89b3d218f7e49ded18ebec08908d5706857e6dcc945d"
    sha256 cellar: :any, sonoma:        "40c294994a0e17821a7eca6ec7e50f073b7f322fba126a48d3f961a335e0d62a"
    sha256 cellar: :any, arm64_linux:   "5790f5d5c35a1693f469d1e1cf7c90271a60861e57f5012290afd33afee5ac56"
    sha256 cellar: :any, x86_64_linux:  "6c1b92362eb165123f573493369371bb15efb7009fcbbcc72ec4e1bb3050afc7"
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

    system "go", "build", *std_go_args, "./cli"
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath/"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin/"imgproxy"
    sleep 20

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