class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghfast.top/https://github.com/ysugimoto/falco/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "4729d525ed08e8539fbaaafa4f0782f806b42a1b140e5fcfdd0832fec8868630"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4165905ac9f92356eb177f9b0af8d9b51a240e28a79d9603eecd657874bf45c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4165905ac9f92356eb177f9b0af8d9b51a240e28a79d9603eecd657874bf45c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4165905ac9f92356eb177f9b0af8d9b51a240e28a79d9603eecd657874bf45c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "523ff76a1c6572b550b77798350e2dab79514c2968dcb93ab5fa02268d0bd47d"
    sha256 cellar: :any_skip_relocation, ventura:       "523ff76a1c6572b550b77798350e2dab79514c2968dcb93ab5fa02268d0bd47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595bef1baabe4fa7a6df372b0af80e2bccfd7e97e51314d116f500688b7796db"
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