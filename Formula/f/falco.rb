class Falco < Formula
  desc "VCL parser and linter optimized for Fastly"
  homepage "https://github.com/ysugimoto/falco"
  url "https://ghproxy.com/https://github.com/ysugimoto/falco/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ddb639f2d572c9c8235458f25cd56a58f66a08fd11bb2f7c5af3a0668d9618f8"
  license "MIT"
  head "https://github.com/ysugimoto/falco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dafa42f25f003e3f93446c7d70b61cabbc1049c81a25973d2889bbeae704e7a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caffbf6030c3c3345866a80ff6bc84c5299a4762526bca7cc652b586172c846d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf6916b5249843af2a9d9df65ae9ee257f072e39a4d239e61e36205cab2cbfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4bd7867ca9d5facedaed5204491a733d0d4aff5ffdac34e23f1ada8df6ef715"
    sha256 cellar: :any_skip_relocation, ventura:        "3861c2db6b33dbd3f07670419e5f2526caae37fdc8a3060a1db104e7901dac2d"
    sha256 cellar: :any_skip_relocation, monterey:       "86fe54dd1418f28aa5870111209dae16414de415a228c03ff1b44e7ce9aecf82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0902e091d38b90cc7b5be841f0504abb194490d59ddbdef6e85190b402a9f906"
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