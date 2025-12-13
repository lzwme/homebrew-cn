class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghfast.top/https://github.com/ysugimoto/falco/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8dd8074b8cf198c1925aebf1003b40a9e20e04f9eb94ae3507e722feeea3d16c"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1377c352c9601da06adc9f2202e646b358e49f85b6a9be53e9b98d1376badaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1377c352c9601da06adc9f2202e646b358e49f85b6a9be53e9b98d1376badaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1377c352c9601da06adc9f2202e646b358e49f85b6a9be53e9b98d1376badaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d8546f39800eb14b6d6e2c90799fa50edde6ace527e97f868e003bc2d97dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37911ce3f2d8d1ac7319b55ab93cf248dc9456b05c29496f1b0265f6f66f8ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5c0e51cfa9c42489d3e04557837405d4cd9f080cb6cb261d407d81ca21be91d"
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