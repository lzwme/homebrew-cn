class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.13.0.tar.gz"
  sha256 "cfae404834f5d90ae33f0d2f51cbfd9c93dd7cb3478f8f35821b16970b43a6bb"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dee72a233a8e5a45378d87a767e5d99222be8da7e2d9b2cb7305f73a4f115b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dee72a233a8e5a45378d87a767e5d99222be8da7e2d9b2cb7305f73a4f115b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dee72a233a8e5a45378d87a767e5d99222be8da7e2d9b2cb7305f73a4f115b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff745f471b067a503fd21ff7163b46cbff9052fea24068fa295810a8e8e03604"
    sha256 cellar: :any_skip_relocation, ventura:       "ff745f471b067a503fd21ff7163b46cbff9052fea24068fa295810a8e8e03604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66fddffbf8e3a8ae49ca6bd4a1c643f7e2582e7dab9b846550ba0a0e44597e03"
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