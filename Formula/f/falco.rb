class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.18.0.tar.gz"
  sha256 "3743e5fb0cd8d7ec76c728c74434633ad46c7e65c27d1cebfb8afb96b7443b96"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10c1dea08f52c19dfa5fd3ad26505b781c0dfd979dd139a916aa33964829d59e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c1dea08f52c19dfa5fd3ad26505b781c0dfd979dd139a916aa33964829d59e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10c1dea08f52c19dfa5fd3ad26505b781c0dfd979dd139a916aa33964829d59e"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a4952f6b451fcb02d6c113414e4f05b3475fc32961f53429a5b45db7414397"
    sha256 cellar: :any_skip_relocation, ventura:       "95a4952f6b451fcb02d6c113414e4f05b3475fc32961f53429a5b45db7414397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b547864442a59c706136e3b99f196c933cf24c60d23a4697b542c00f2dde85"
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