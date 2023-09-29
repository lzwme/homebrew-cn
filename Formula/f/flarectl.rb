class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "17cec0eb774bcfe44efecbc2eebea2b4d4f632b1d36eff474b710e096abec03c"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1956a730ec87de30d33586f286f74d01ef87fe750ae9778a1e575372893a565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cce75755946b82852f98325b0f2e55eb76bb32b39d91a661723ce5e9d2a511d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6590d95cbc8ef57095349872e128a979611a22e91110ea379949aef874d5843"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b6e2201a59299e5b23ca45df4702885c103787b959f4bae9f1d441de6b5705a"
    sha256 cellar: :any_skip_relocation, ventura:        "091b93279e054508cebd76a4a023292d30e9f7c0927ac85b498dc769a69073b6"
    sha256 cellar: :any_skip_relocation, monterey:       "72ef172acf5b718e8f858e0e42b4f0cb8dd2f867f6fa8a778df80b12e8f82b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0afbe5bc71dc4a0f82070a4fbafdc18528eb3e8b6185876f660f67ad8aa30ea9"
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