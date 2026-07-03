class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.9.tar.gz"
  sha256 "fa3b72aad70809889ea81e232120b39a9ccad2640349bc7bab3578c75121247e"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a856a607ab5c4ca19d3e518744274274e20c9e140d144b59d248eb092f9c2a0"
    sha256 cellar: :any, arm64_sequoia: "7bd3410dcf179182c18ac5a9c16b4447e669952de09ca6f19611b1db0b103dd3"
    sha256 cellar: :any, arm64_sonoma:  "5ac375bb9626f61bedc2b6f496030d6a91f6cb096fcff42703d379603fbae837"
    sha256 cellar: :any, sonoma:        "a61b63eb32c33fddc8e64a795cfdbca50c723fac1a6013666524132d634f4f97"
    sha256 cellar: :any, arm64_linux:   "db9f68fcd34b5c23cdc28d4777bf4c7fac21fbac28e12662026f6f48f97be047"
    sha256 cellar: :any, x86_64_linux:  "ea5178ef2deef4119926c59af2967a4d61dd1bbc6b5cc58807ac6fd6f49a288f"
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