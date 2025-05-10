class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.17.0.tar.gz"
  sha256 "a4006ba07678f1cd82dfaf3eaf2747fabb23a0abc38e661936dd8f2f38a141b0"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3c0c6fb52a1a6cb077358496872538bfca3ddcd5fe44d645c18768f919418fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3c0c6fb52a1a6cb077358496872538bfca3ddcd5fe44d645c18768f919418fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3c0c6fb52a1a6cb077358496872538bfca3ddcd5fe44d645c18768f919418fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3152a662a9c28eaae54f874a92dbbe7dbb5c52ba2397cf5d1ae9498bf7f006bc"
    sha256 cellar: :any_skip_relocation, ventura:       "3152a662a9c28eaae54f874a92dbbe7dbb5c52ba2397cf5d1ae9498bf7f006bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac5765774cf7f07cc5690be7e77b23776c25863c49825c8ce2e640287826f066"
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