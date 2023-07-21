class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "93b14b36a80b9eed772ebf714db5173fe93170ca74d94b810d75ac2f2558c195"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69109338dcce0cdafc87ec81c3661145b4c022af58bda4c6c0a7c7ad3d7fe275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4aace7f0e75873e175c02fa810f15098c17a7ba2565da3259a4f3c441e5bc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a94cff2de3faeb983043c4af20ec7f049ce438203f35125033bf8d2611610dbe"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b7cebee5c6efcfcfaec691ee3864bacd0ac1a4dbcaca561a8ae01f8a8a4129"
    sha256 cellar: :any_skip_relocation, monterey:       "4e3dfdc3c4b5731b64011b011d3dc96b92a146059c93311793c310322d6a77d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd9ac7b31ff3ee9e9f80e3ec68be0a23dffff86be799dcbd0aaedd0d98dfe9f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba42c3ec286343387ab1a0dc8f60a532f4712b416c736fb32a424bad4970ab2"
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