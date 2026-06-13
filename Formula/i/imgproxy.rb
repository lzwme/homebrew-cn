class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "61b1d880a8f52f95ca0a1d235c51461368130a0ebdc5c1b33bcb99f00eb4c8e4"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff2841b4c2364a5bc8ab6c27be1505c83106873fa51260e468b9ebf32d5d0c7e"
    sha256 cellar: :any, arm64_sequoia: "b89ef7e6b6da055e26c5d9fb2ba8f71742ca205560948e5443c91fbcea86f7ea"
    sha256 cellar: :any, arm64_sonoma:  "64d691e3bb1909145979b52e17ef4957028fd9f63a2f34300cab0bb672fa533f"
    sha256 cellar: :any, sonoma:        "67618db2e1b125724ded7f2685d59e62329d0f8151bab401a4167d168bddf70a"
    sha256 cellar: :any, arm64_linux:   "d3406099ebcd265800a2935868685fe1910acac3697cbcc08e12832684107199"
    sha256 cellar: :any, x86_64_linux:  "06f21fe21d2306583071bdd89d4ea60ab2d1096b80b03f43fcc718f71d94a23f"
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