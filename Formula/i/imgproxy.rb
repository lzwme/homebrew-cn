class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https:imgproxy.net"
  url "https:github.comimgproxyimgproxyarchiverefstagsv3.26.0.tar.gz"
  sha256 "6125d230b35cca2b0ca53e06afd82b1bb01aafd0eee2e6617cbd9f5fab6c9e31"
  license "MIT"
  head "https:github.comimgproxyimgproxy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2a568c5a604ccb1f091d90b14738baf4c9e45bab7a4424044466f24e068e47cc"
    sha256 cellar: :any,                 arm64_sonoma:  "39daebbe6837a0409ee37b0e341503cac862bab16fc5041cfc8af92c09dcdfd0"
    sha256 cellar: :any,                 arm64_ventura: "3c0041006749b164261e3818e9ae178d75240b527b6fb893fdd3f19939be11f0"
    sha256 cellar: :any,                 sonoma:        "d69ff56f009a15bba489ebbd6f58d0920a745e64e270f9851b580f0f24916bbe"
    sha256 cellar: :any,                 ventura:       "716c129eb8e635d0cda108a9fd21aa8e2f2bd997d1663621e260ddbe8d6f3036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b0215e1db006c135151be22ee931213d63c23377338efdd289ac9d7988b5fa"
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
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

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