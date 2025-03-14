class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.15.0.tar.gz"
  sha256 "3addae14e1472ba898e43add368b38d088fb620a04bdf92bf5822273b9230017"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6bc2350feaf8b20adee6ed004e92b9fa3f5ea1c412e10a4b3557706ef356110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6bc2350feaf8b20adee6ed004e92b9fa3f5ea1c412e10a4b3557706ef356110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6bc2350feaf8b20adee6ed004e92b9fa3f5ea1c412e10a4b3557706ef356110"
    sha256 cellar: :any_skip_relocation, sonoma:        "119cc17c6e1df2f7b1878409f5a151edb2213e09e4043b8a16991756c12d9df4"
    sha256 cellar: :any_skip_relocation, ventura:       "119cc17c6e1df2f7b1878409f5a151edb2213e09e4043b8a16991756c12d9df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3727c9eeee6ae21875536d8c34f4222b3bab82d100eda8c2f9bab801b6be4fe8"
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