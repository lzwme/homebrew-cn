class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.14.0.tar.gz"
  sha256 "6c5949b4200665b58678313f2dabc978d2b20afdd30d71d51563787c36cd1a5f"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86bee0fb45d0b95ef1ea7d7c43292347e877c5e88618cdc0cf5c82df2d65ccf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86bee0fb45d0b95ef1ea7d7c43292347e877c5e88618cdc0cf5c82df2d65ccf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86bee0fb45d0b95ef1ea7d7c43292347e877c5e88618cdc0cf5c82df2d65ccf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff7bdc186f4165a1c367cdcef3665a2b6bf404d110a009b6163a386654ccfc7"
    sha256 cellar: :any_skip_relocation, ventura:       "4ff7bdc186f4165a1c367cdcef3665a2b6bf404d110a009b6163a386654ccfc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d720c41729b59401c4cee2c6266ed5cbaa6702a5a49ba587b5765f8ebf985409"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdfalco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}falco -V 2>&1")

    pass_vcl = testpath"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}falco #{pass_vcl} 2>&1")

    fail_vcl = testpath"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #FASTLY RECV
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}falco #{fail_vcl} 2>&1", 1)
  end
end