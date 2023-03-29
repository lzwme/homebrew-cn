class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.6.13.tar.gz"
  sha256 "86ecf8043e2a57e24e34936bf95bb3a6b2736280355622579890793f048db716"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56a202d243c9e2a7a969ff18f6a87e12f000676f390b64321f6fa06ea88c8edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dfa5d803cb7504f01d47510848fc50032f7beeff8c040393be5b02baf6a396d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba0108f2f5654940910c6eb08401d1b7ba3578cf47fe37c076c38651bf607bc"
    sha256 cellar: :any_skip_relocation, ventura:        "7cbe979752a42f92b18aa209dc1d907c220365aca06b17ac9fdb5cf8adec433a"
    sha256 cellar: :any_skip_relocation, monterey:       "424b5db03aa14d83636107df906c0d826c9ef217d13367c149a060a41a14542f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd6e21626952863c6a9b1d3930743c4785c8bc5143a7ac6315f1de840442252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccb84a54dfa9c4a1b5e9fabd4a5b0f6b0a820768c9da607ba9999cf5114f1ce8"
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