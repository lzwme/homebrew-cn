class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.19.tar.gz"
  sha256 "16b980edde124fe394446d1e356ba406a0ca5de0dbe46dc98763f683147fcdba"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5dbc845dffefe68a86b9b691db6a97f21b399a35ad4732f737fc794c0fb6c50f"
    sha256 cellar: :any, arm64_tahoe:       "dab3ab85522a58b270620747b65e66d27136b6bc6f8576d4dca72c6b890c22f2"
    sha256 cellar: :any, arm64_sequoia:     "773527b9ef4dfa3af6de3d7822bcf32b9802031192746d7da4dfd407d5675ee1"
    sha256 cellar: :any, arm64_linux:       "742ae737e7d796a3600ccb176eea9734ada2c6020d1f98cfe862fc41eec0e64b"
    sha256 cellar: :any, x86_64_linux:      "5b69ee23c2f769a84dc44ebf1fc5eeffd9bf115f8a5e08f3642a9eba6f49f23b"
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