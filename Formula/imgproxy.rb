class Imgproxy < Formula
  desc "Fast and secure server for resizing and converting remote images"
  homepage "https://imgproxy.net"
  url "https://ghproxy.com/https://github.com/imgproxy/imgproxy/archive/v3.18.1.tar.gz"
  sha256 "50972124fe9a74aa72d7b1e58c113d5312aab64f28f696f32d63c7eb74575760"
  license "MIT"
  head "https://github.com/imgproxy/imgproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da603e59b353a694ef491c5806086f70980f033edaacd978aca32ea4fd946f4d"
    sha256 cellar: :any,                 arm64_monterey: "19613bcf28e16c470704cf988a13122ad0a8e4fa78eaada986dd852b941cdc1a"
    sha256 cellar: :any,                 arm64_big_sur:  "ece99570436a0ec652ab862da76fc528423cd48abfdd2514a3861c02faf7889f"
    sha256 cellar: :any,                 ventura:        "7a5716cbfdd68fcb7adaeb0f5e4978e383777cbc17ef0ab7c44f9b6f36e8f036"
    sha256 cellar: :any,                 monterey:       "b02f0c1ec50b784c2cbfab82c1aa2e93e047a65cd5908a5aaf1f3bb567b1ed4d"
    sha256 cellar: :any,                 big_sur:        "f1c0403c7a5e9a24504e44d01508ce56b0b5686de11cdc8c433d768a21d0128c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e861caf7968050616e1d82928a40b4a51a245182b9f700f4bc28e1743cd09802"
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