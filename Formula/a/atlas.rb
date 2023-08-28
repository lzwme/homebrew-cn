class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://ghproxy.com/https://github.com/ariga/atlas/archive/v0.13.3.tar.gz"
  sha256 "d1891c73e307402f27b22ce0e969c0c3781c9289f1d30ddac827f106444b518c"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f3ef1456520c4f2aee04d71712b7d6fe0f2d381d5c7efcea92b681afbdd61da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fb5cc1ff1012d709b98b5c3439f68b48a445ae5e0def6211a4cc083043399b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d22e5a91c8779e70c748cd3366b9459af0e7a8c9fd19a70bfa72fc18599e2cbc"
    sha256 cellar: :any_skip_relocation, ventura:        "3acf4e7c2011dce25de9dbcdb9d3170186f840f9a118e9cee42d011a0c68c1a5"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b4e6072d5206aecf4a74ed056bea0df03af5d79848c288b6406c7d47d1154b"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b97ecac4c3cec422f24a7f3e9dbd0a16ba0cadd6fb7653e1e8ae250e9e5d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6d83b50285609ce436fa5a1b893e9bcb633c84a2f39ce636f78615f9519727"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end