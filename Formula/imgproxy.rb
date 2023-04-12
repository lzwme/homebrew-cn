class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghproxy.com/https://github.com/imgproxy/imgproxy/archive/v3.15.0.tar.gz"
  sha256 "57077545c3aef8895ac5b92e7896779edf1200e819f4799c8d05d28fdd21b55b"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "004cb6eb948bde2e116781179a2bd1710aaeaea23c98b659194038d70a1fdae3"
    sha256 cellar: :any,                 arm64_monterey: "b6037584afd062c7c73a97db1dc31c518eb6cdbf5fa9a15e2e6fe934eee120b7"
    sha256 cellar: :any,                 arm64_big_sur:  "9a595c22b1b922a68fc49f191a34511a32b51715da1298ffb5a806cd20ed3be4"
    sha256 cellar: :any,                 ventura:        "e8c39e4b9e00383535f9b4733953f64276aba7f14473f2663bba2d9192c857e3"
    sha256 cellar: :any,                 monterey:       "b0a7874c331ec096bd6b7aa7a4e03489e2bf414f2d8ae0331f5ee6c4070d5bd3"
    sha256 cellar: :any,                 big_sur:        "69a1f610f1772af60e12281f7021f5f00cc241003c270262c9a2ff5dcbebb96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "824c095e134e4f4c6bb10882ad4cc246aa91ee1f3c526c79148f12bbe7fe51f9"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "vips"

  def install
    ENV["CGO_LDFLAGS_ALLOW"]="-s|-w"
    ENV["CGO_CFLAGS_ALLOW"]="-Xpreprocessor"

    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    cp(test_fixtures("test.jpg"), testpath/"test.jpg")

    ENV["IMGPROXY_BIND"] = "127.0.0.1:#{port}"
    ENV["IMGPROXY_LOCAL_FILESYSTEM_ROOT"] = testpath

    pid = fork do
      exec bin/"imgproxy"
    end
    sleep 20

    output = testpath/"test-converted.png"

    system "curl", "-s", "-o", output,
           "http://127.0.0.1:#{port}/insecure/resize:fit:100:100:true/plain/local:///test.jpg@png"
    assert_predicate output, :exist?

    file_output = shell_output("file #{output}")
    assert_match "PNG image data", file_output
    assert_match "100 x 100", file_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end