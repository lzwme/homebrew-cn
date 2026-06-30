class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.8.tar.gz"
  sha256 "d66a027091cbf8e7057d863aeec7dfb33d2be6ab23e0a355d1efb99f748a188b"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e4b99f6f324c66ec35fff493b118f36461fadb2ba352dd80f7ff8b3e1e3d98c"
    sha256 cellar: :any, arm64_sequoia: "a5777841cdf9db8ea463728bb5f12b19a4129dec6e09b1d8428ef92a77da380d"
    sha256 cellar: :any, arm64_sonoma:  "b6610e5175323d8d1d78a38afe76f82fc976226bcb218ba0d3ceb71263160017"
    sha256 cellar: :any, sonoma:        "a1f6040202a0166274ed12c6e254eae538b250eb8d8b120c18f6d1663f8298e4"
    sha256 cellar: :any, arm64_linux:   "55620a8f71149fefb74270a16cb17298d7393b0a720af03acdc2da2212e33f1d"
    sha256 cellar: :any, x86_64_linux:  "6fcb3e80bb5bf4d5718a890282242892619b446dd0f8ae1c34e40d79b1e601bf"
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