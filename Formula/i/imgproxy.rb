class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.17.tar.gz"
  sha256 "d376aa6e44f8730b7123c13e948a3e224e8f21448d93e78e379fbac54a9d852f"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e9f4c2568698755fd5177437db5e000ca6196d95b65c061a71c1980832b233e5"
    sha256 cellar: :any, arm64_tahoe:       "0f446630ba37e8c22fe39df7bbda84650d6d8611a5ca3dbce3575a1f2fb87fb9"
    sha256 cellar: :any, arm64_sequoia:     "a8a8413adc6c2ea6bd2e84eedd98ba6b458fc65c1e7c9e3df98b97c3525d34a3"
    sha256 cellar: :any, arm64_linux:       "285c25087403176b64d36bb8302dcfba0def625af889acd560b802c1987e40eb"
    sha256 cellar: :any, x86_64_linux:      "ed350ec2c465498148c71bd361f276eb182c291005dae9ea6ee66d8ee95da317"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
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