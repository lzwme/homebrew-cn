class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghfast.top/https://github.com/imgproxy/imgproxy/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "02190571e68cfef01d7c0714654df1042e36b5bffcfa6ce28562bdd2a2e7dc62"
  license "Apache-2.0"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69c058b424eb4879f86cb49c1210130c2eb5f6cf470e5340f0bec80c635fdc26"
    sha256 cellar: :any,                 arm64_sequoia: "b0f7159ce7ea0ca2de45f7bbac35da164705e3d79a393c1cde715fcc76902fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "715106a0d8984108daa95d0f262f8e7b8aa7953f0af9f0fc72950e1b880ae7ce"
    sha256 cellar: :any,                 sonoma:        "24261246d3f8455fe4c8950a79d81df433ebb55f87656f9a8c3b8e9c80c02636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b2f0e717851639afdae8862ba0be6bdc989b330413fba2f85e446a0a9d3b5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc3cefb1677aa767187f0a3a6e0c91b6cee10daf89362a1369f528efc17a5d7"
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