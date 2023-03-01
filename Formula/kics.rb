class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "3150610df73d8393245bb47c1720677148dad1fe55d41140caca5436b232dcb1"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e24e206004866370c76847331388d2672cfda5bd8097f3a40d2eba907419d50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "535aa788852b8191c67c2e783d1d5c26e3dc3cc57186e35a9bdb67c5e1cdb494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc941fa38e32ccf8a222969df0271dc78d9e256adbc4c9adbb3d7c90350642d7"
    sha256 cellar: :any_skip_relocation, ventura:        "4ad9717e9186e30fa6269d0d71edaf429c3ecc89630ad9dd7fefabe3f094a6ce"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b1ace000b0df80212a8225bb7b99eac799669f3bad0e1a54ecdfb6807ad827"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1ebb493c64b65dc48e75aa9321c6926f3fe5d1863ef9ad0e25c68aa8d06f839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd98fa9f8090a388f245a33143b8c4751dfb0ba25431e03b95662c98c041a9a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end