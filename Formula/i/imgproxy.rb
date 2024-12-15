class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https:imgproxy.net"
  url "https:github.comimgproxyimgproxyarchiverefstagsv3.26.1.tar.gz"
  sha256 "734fab3838efc1636b51680889e9360752044c37fe78ce2c94e6dd47b91d2637"
  license "MIT"
  head "https:github.comimgproxyimgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f5c22462d4b79989951dea0000b16e395f1cec28a74b2d812e6b9a0ebc431f7"
    sha256 cellar: :any,                 arm64_sonoma:  "2241f7036c3136b756990ccc5ace4fe5da7fc5f94887c49dcbd0d92e990920c8"
    sha256 cellar: :any,                 arm64_ventura: "8e8f4f647146c6242d7c297e5e0f3f48101239a652cdd16f93f8cf24e831d75b"
    sha256 cellar: :any,                 sonoma:        "8af4e5dfbb47565e7be0471feb48fc093a1414d9dc3e7b2eed003cbf35f9fe2c"
    sha256 cellar: :any,                 ventura:       "43188f27ed7af56ae97975541ac5ade2ee3e134204ecd49a8afae01724be601c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04bc980c7823f1930fa41a529cc470ce5f24ac5adddefdf7881059a3c9453ad"
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

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    cp test_fixtures("test.jpg"), testpath"test.jpg"

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = spawn bin"imgproxy"
    sleep 20
    sleep 40 if OS.mac? && Hardware::CPU.intel?

    output = testpath"test-converted.png"
    url = "http:127.0.0.1:#{port}insecureresize:fit:100:100:trueplainlocal:test.jpg@png"

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