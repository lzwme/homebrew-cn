class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.9.0.tar.gz"
  sha256 "e205f460da2437fb7c2a59f6b1fa090c23a720cb9164f7a9a9da903ebab862f5"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ab88cc276d5931ab96f09efeec4d0b4e62093b90d55581c8afd6e3b8b914c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82bbac7634ff6211d52b734f8a319c54a992690b46c502f15aad4773394b3ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56a30b4153f4a5a738417b2e0592682bc45981ba6755eba2ede3517ce80cf4f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e638396d6eacd8e1fd81936d05c32f1726a332bd5c698a8552be69e2d1efb979"
    sha256 cellar: :any_skip_relocation, ventura:        "f55dcc9b14390924488ff13be6277be2f4c873f3cd761ae89599cacb0abbfd72"
    sha256 cellar: :any_skip_relocation, monterey:       "c787db6bf0daba48b50a33122b1d51c1262e96cc06bce73d933d071dbf4e82f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b3e1c7da476d99319a20a11f5e70d543f98f6e50ca778b05f25cbafb5cf7ec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdfalco"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}falco -V 2>&1", 1)

    pass_vcl = testpath"pass.vcl"
    pass_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        return (pass);
      }
    EOS

    assert_match "VCL looks great", shell_output("#{bin}falco #{pass_vcl} 2>&1")

    fail_vcl = testpath"fail.vcl"
    fail_vcl.write <<~EOS
      sub vcl_recv {
      #Fastly recv
        set req.backend = httpbin_org;
        return (pass);
      }
    EOS
    assert_match "Type mismatch: req.backend requires type REQBACKEND",
      shell_output("#{bin}falco #{fail_vcl} 2>&1")
  end
end