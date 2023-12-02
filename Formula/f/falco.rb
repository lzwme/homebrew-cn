class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghproxy.com/https://github.com/ysugimoto/falco/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9da932e73f14cd14a7dc89293e4e79ca1f2bf2a8d6370467ad982865740fff27"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857d851a8c9bf536f286acf2d4b7ca9d7b61cbaadc1f6775680c7236e5a0e49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2df6ae7c7243ab6b61feae7568ec3c06ade9d2da469dff71bac6ac02cd67a518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3769c7caf25bea06d058c8252b793eda57a36f158627be83033399a6e524e51b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2c52599612b3669f05a7e50937c9c5c3cd5fcb775b5414f9e9b633f0da7dd13"
    sha256 cellar: :any_skip_relocation, ventura:        "c018efa93b2cb256e16c1a3bdce3ecb7c726dc06097da710f5c999fb25411ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "19e92b1f2b2c34f4dfeb95e975fe781f9637169dced874feaa4c8d29a6f84764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26bd117174f14feeab201cd9849e6f51e8f2a0393388669f95482a1f8df9ad97"
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