class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https:github.comysugimotofalco"
  url "https:github.comysugimotofalcoarchiverefstagsv1.7.0.tar.gz"
  sha256 "3e41f830f48d8026c1f96184e60f7e0740fee7fa0995355a93bb6059f41ce335"
  license "MIT"
  head "https:github.comysugimotofalco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc479fa350284b5f498b107b82dabd51152406f3f1785e4fd49b45a5ef64551e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed92b02154bd2f3a93b7f26e316747ffe49a077891503a6b878ed8535d3638b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "779ffedc98dcf0626415225461901125008f8b0797d1d92a224c494adb5715e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6374473919a580e11d2d1ebef14d7e47bc5641a2b24a8011af1f1fd3e31de7d6"
    sha256 cellar: :any_skip_relocation, ventura:        "3cfd82150b6e831c09d4ac4f0111a427a97fca35835a5bd55a09699067e9b136"
    sha256 cellar: :any_skip_relocation, monterey:       "68ab5846abc93dcb3c8dff9cc22a0b866fba37adffd09d428c356dda1973aeb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "618f683d37439e1dc1f5fdc74f2f420c865e3dd473ee2e7ac4a67bbf43b75103"
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
      shell_output("#{bin}falco #{fail_vcl} 2>&1", 1)
  end
end