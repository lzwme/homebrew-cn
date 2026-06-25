class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.6.tar.gz"
  sha256 "df9b31a383b01be8320960cb9df849ea9e12d2f366292a2a263dbd03355fe5b1"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aa113bd1d26fe6ca941ba678f8fd5eb521d9e2693991f67cc29b58e0e2a49273"
    sha256 cellar: :any, arm64_sequoia: "abc818e7d298e269eda8726701713b6e7a46fc6fc0d9906852eaa6f4f565e136"
    sha256 cellar: :any, arm64_sonoma:  "59e8b87343bfd2c0b599ce2b02c69de9be6b8fdb00df6fe2baeeb4d9ae03d173"
    sha256 cellar: :any, sonoma:        "b2132a4d2fb28c2c6f9f8860f3b1927c2cf928a0b0023b6f8dba1adf3056665f"
    sha256 cellar: :any, arm64_linux:   "673fc307c0d06d8731bc8dc0e22068422e6600ccaddf99132aaa90c539445b37"
    sha256 cellar: :any, x86_64_linux:  "4b8e5b8cbb2a28b5b66304557375d356bc86e3b8e5f50a22f269dcc8d6660e70"
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