class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghproxy.com/https://github.com/imgproxy/imgproxy/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "f8c3b94c6db8674028e419da43adfdb9636c39c3e7f45ef8191ce0990106aeba"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9f6257016da12e06ac81d07750399a283ed4bea9dd5149d9236bc3d172f5ca1"
    sha256 cellar: :any,                 arm64_ventura:  "2ce8bc83b98eea376333d3197805e0b84152261841e9580008fab33d975ce7c0"
    sha256 cellar: :any,                 arm64_monterey: "2748a5f609b9aa5bf8ba1840e5e87ab3fc1cd89d50e799b2ae94bac7e258905f"
    sha256 cellar: :any,                 sonoma:         "9ee580886fc263fa789322156e4473decb82ad784c3972e2f72da01e36ec402c"
    sha256 cellar: :any,                 ventura:        "a826808292e4193dae832fbc227ba6b0e9f4d7cf4145ddf9292e7c1a50e03d9a"
    sha256 cellar: :any,                 monterey:       "192f731ebe80865466f3415a398fb57741a61ba95dca09207c510dc340cbc064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "394b047653567b2b175c18250ae33053161551e0c3cd8ccb76431b9e5a598d91"
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