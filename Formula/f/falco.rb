class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.15.1.tar.gz"
  sha256 "3ffcfc8a92c06a09637afa2b3b2ee3db5efb28538c67d0cecf54dbad8f4a94d8"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03b8e5433a01fe610c2a1233c43bb87e2ed20278d178eadf38ab6653e12d8ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b8e5433a01fe610c2a1233c43bb87e2ed20278d178eadf38ab6653e12d8ba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03b8e5433a01fe610c2a1233c43bb87e2ed20278d178eadf38ab6653e12d8ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb34c0145c18443b5b1fd1903b697d05ce4edfdbde5dd9714c31dffc08f3346"
    sha256 cellar: :any_skip_relocation, ventura:       "ecb34c0145c18443b5b1fd1903b697d05ce4edfdbde5dd9714c31dffc08f3346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5a5b2d9f6bb96f32f27299ed0c37319ec61d7660c6fedf02097692a7a16d9c"
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