class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://ghfast.top/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "d798661f7f8a3356228d6313d0471270e243854644b5dda16999d7ca23ca17ea"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "266f66a462b3875578c22bea5170cf8e977fcdc5d888649a70ac814ed141f3eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d274a5c3dcb284096a79d57be549266700c1a089b7b80f0fd8f89a52020090c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39946450147e839fad9fd947886c031673b631d622ade1356cb4a4d5605dd4c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9587344f80ee232386af33a6e2d0a14300170ff69b355b7ef269ffc173d19742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baadb8a80aabe358dbf02e30a764fe55593a95f56c7b6cdc7c998d8fcd3c573d"
    sha256 cellar: :any,                 x86_64_linux:  "206658867c83552b758524d850328a5bab49d3e89e5816e34a54889ca75741b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end