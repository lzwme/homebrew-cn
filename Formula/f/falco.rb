class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghproxy.com/https://github.com/ysugimoto/falco/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "67a90ea8f73cbafd5df1e17094e5aa897d1a1a65039bec2bb875dabf6ddeb9a7"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a1347e6d4abb94eaf4b8da65507fb087e0b8538e2a8149ccce8e7f2c288d0dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f0ee8600f3339c700ed1d8a4ff15db13cac3055efc65b5bf847874a03bf30cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211dec2e3dd8940f5667a746a9fe5c186c06009b85fc59dd68b50256ac7f4b5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a979febc2d978c2142859c3bf88a7231acf806aedc580b87684a28718cdd7f4"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d3e886ce565f386e052b1aef8ff041023d0ac1015c408fbd268f8cd14f5161"
    sha256 cellar: :any_skip_relocation, monterey:       "23acd9e08a762ac18a3631b67f8a332f907447bef0f09d0bb76cde05ea422ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c551914eb48210de5653f7c2d67810cb998ab2cb70e924fd275a1ddfbac66a96"
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