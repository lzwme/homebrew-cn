class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghfast.top/https://github.com/ysugimoto/falco/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "695da1dae232b9cf6e88a9327d3cc11de58b20617343ea4f73d40487dc4b3d30"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e03d5d01b74636743f3152b9080f791e92796175439b869c5a610d76ff72d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76e03d5d01b74636743f3152b9080f791e92796175439b869c5a610d76ff72d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e03d5d01b74636743f3152b9080f791e92796175439b869c5a610d76ff72d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e4a6cb8f4b6b63a9250a0a72ea90dbef7952774b6c29f02a73f38f6fd9dea6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b24ffb96cc2957470e68bfb3e22d1e352e645431a887f42b3602748c3affa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056048e380c09f31c0c1352f8b51961f917ab2daa69d625b41063e83ed1cb72a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1")

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end