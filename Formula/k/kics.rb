class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghproxy.com/https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "bcb5a5710d184151407e9b8065e3323a2501ee9c96cdba5bd2c15f9a0c76e1e9"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14c65e785aad75f4a4ea502d6c0e51cff5600c71c203a4f8bb66dc590f7fee8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4415c08cf882b106e53cf6b9f8528a0c0e2848f44b6ddf74b123f0ffe3546562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342664ee163e4d42f127b281a5f3782633c70ff1e3dee8430b708e30353ff6d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "50aac5cf7a3f35a063ad281aa7dd88f73dc9925205fe95d92473f2e5b97a1d0f"
    sha256 cellar: :any_skip_relocation, ventura:        "1c0919dab8c28cd4bc878a4193a379f6340e959f508d3afbcc2f19968f146660"
    sha256 cellar: :any_skip_relocation, monterey:       "33623c7a7100bdc551b4f065358d7394b322a50e52f42ee1a949c663db4a04d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed79f8b0d425e430c9faf87bdcab7b221063bb225bb9ec16a9f717021614344d"
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