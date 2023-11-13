class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghproxy.com/https://github.com/ysugimoto/falco/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "12a6130b90195da731a84d5b275783b07dda73230219336bfdf8da7709adf3e0"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfe7cd9265e1b63b61498ceb641075730abb8fb93db6de9de203726488914284"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "840d06fffb78af89b29cb8774728b304dc0ebbbbe95a09a00f15e76c2f6268bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472f5dcf30451320254d02b87aab4dccd1519228109806e70d71037d63b3f19c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc990ff2e9c04e2eda047412ede65a5f9869e19fce00e86a7c97c305dd4c1de9"
    sha256 cellar: :any_skip_relocation, ventura:        "947b488a0cdc0e07dc1f13f75c17bc2b71ab6b0771c52a307b95fd5ca425ce5e"
    sha256 cellar: :any_skip_relocation, monterey:       "72c132497912f7388c008d023ab860587b668b4d86e0bbf5c656d5110d83739e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b28163b3c43305631b4e5b246c4fe23a3a1e991dc5f8a27840fad0bb057aaa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/falco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/falco -V 2>&1", 1)

    pass_vcl = testpath/"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}/falco #{pass_vcl} 2>&1")

    fail_vcl = testpath/"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}/falco #{fail_vcl} 2>&1", 1)
  end
end