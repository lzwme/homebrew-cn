class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.12.tar.gz"
  sha256 "8686bd43a3ab0be41640c7ade272e20b1d0f39bedb0924a39163d05b590ae7b7"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be53530dbc0030b9f2bee6b270be98deed7d16cfe2b900e78f082af6f5f6688a"
    sha256 cellar: :any, arm64_sequoia: "0f6df8b2989aa209aa3bcf9264c1249f8a52a1721557f572349746d915ab007f"
    sha256 cellar: :any, arm64_sonoma:  "40f7f7814172a8b09af4323fbabd052cc6ba4156237f9b1432d9bb3f5198ebaf"
    sha256 cellar: :any, sonoma:        "5348a9a80c25093bc273c57764e97fa905dcb0e0317ebb9d87551f0d0137c468"
    sha256 cellar: :any, arm64_linux:   "73e3fcaecb0069517076eb2cf78f08391acf745cfb1cc53b80e2ac70c6ac998f"
    sha256 cellar: :any, x86_64_linux:  "35ef1377f75520fbe8e7959b45e8c772c82f7e838e9e64e1a76d2c43c2a59cb4"
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