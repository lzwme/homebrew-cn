class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.16.tar.gz"
  sha256 "1d0c00a35d946668adc51a7eabc153a119b21d383b8f38c771f7cf078c1844fc"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "57a3dc29515ccc148cdb46d55f1c13948962fa093a74c976d72132bf0502fa74"
    sha256 cellar: :any, arm64_tahoe:       "70f333e65cd12990f9aac979a23b0c844960d98ef04bf77ffcc95d8c90500a92"
    sha256 cellar: :any, arm64_sequoia:     "9937c4be5766be6cadb2aa8e25b74e2e46038e98f2fce62be95abe054e1d2ce4"
    sha256 cellar: :any, arm64_linux:       "a774e8d6674275cbc8dd40e3efb83847fbb15836cb07e251d8d94c2b3ab17598"
    sha256 cellar: :any, x86_64_linux:      "fe0cfb05ae04a505797c49e819e79a47dc6b1d276b35e95b9aa52ce149ae72d0"
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