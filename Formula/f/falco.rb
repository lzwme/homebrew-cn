class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghfast.top/https://github.com/ysugimoto/falco/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "f4834fe3cdff0fe76c0c33709504a28058775583eef22582fa708ffdc0b23a74"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa9a71b492dfebddd297ec103552dae8127310890f114235d37111982114f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa9a71b492dfebddd297ec103552dae8127310890f114235d37111982114f95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5aa9a71b492dfebddd297ec103552dae8127310890f114235d37111982114f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "a436b3a8d8047f4ad246799d86830c409df998351bd4afa11e4627d39c529550"
    sha256 cellar: :any_skip_relocation, ventura:       "a436b3a8d8047f4ad246799d86830c409df998351bd4afa11e4627d39c529550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2281396b92d779f41e2e420fab5ce709e4162127d7d9e166aedfa3a31a409a7"
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