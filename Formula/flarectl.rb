class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/v0.64.0.tar.gz"
  sha256 "9067e7fee99d697d69d90a9473be27dcc3fe88c871d5c701405501726c936c55"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9586b60662be7dd761a4ccfbf91a82a94831c114767e5351ccfe3cc355c5e792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a8b1713632a94cb7e4f097ad4493e05601fec1f57bb91d198a562701ee6481e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9def88acef11c5bbbf85cc97fd71505b80bc3479a2fcafed3a3cd7b8e394d36a"
    sha256 cellar: :any_skip_relocation, ventura:        "09bac5233319dc270397346c476c4be932bfe1f5d815c7228aa93adeafe5f051"
    sha256 cellar: :any_skip_relocation, monterey:       "14477df4d68768426bbc035da087c1b7083bca9d8b1edf5dab8fbcd8c94908d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba3ce7b694606cd8335bb78cc00d735b6a3afca5b3ea68db70f152c67de7ab1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1041f771adb283f2f9f4140f4977bbb810929fcf42883bb2e98adcf0f6079c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end