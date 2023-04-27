class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghproxy.com/https://github.com/imgproxy/imgproxy/archive/v3.16.1.tar.gz"
  sha256 "761ab32904dd97e0731fdf78f4dd53cd63b9cefcea751b447f9ca0f21fb2980c"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd7e54a1bf9dd6252810ed49c30a7aa6f2fcdd2ba154902e80a838fe748b52b1"
    sha256 cellar: :any,                 arm64_monterey: "394134029a66565e7145a995b8b1939a472a768d31f2915b58f29b1fcbb76856"
    sha256 cellar: :any,                 arm64_big_sur:  "ddc3196e78060d1c4e380419ea3c602e3d62ada44710797e9f87f8ea19a30c41"
    sha256 cellar: :any,                 ventura:        "e750206e86ab134e96653ac2252928c400f3a698ed34e0b6aa62fca0e5d50c90"
    sha256 cellar: :any,                 monterey:       "e847ea8d8d2efd1bed702ec153c34a66c08ad724542a3efae60a0612892ac643"
    sha256 cellar: :any,                 big_sur:        "db0c0fa806f2b42ae6908f404569f8c2b245672aea9bd1643dac3bd35a563282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa00e6c73bacc4a7a52896bc64ab6a7e64e8f884280fe4db33e8c9de4799aed"
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