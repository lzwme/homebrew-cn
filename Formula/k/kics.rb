class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghfast.top/https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.18.tar.gz"
  sha256 "ee3773db190581b2a5a438333a0124093d93ba1c8332210e0e790f0dbd4b9392"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a260c528a90a685ea1232abef07bfad5445dfa4f3f3ac024dfb2ce78728b605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156b7a994f5a644a729d9eb54411275b4c1f542f934dac36c954742613119675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f1ffd331a6e625ded77f1392c953b4801414569836c94343e7962664e53fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "048f0647dae8207b26c40fbbaa9202913bebe9590aba3f0f793344e0cabb762a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15bd9b13d4c4c2b2a8a7ee75e2daa9892b2a9ab2288658a27e9b28880e0f42c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01dafc973ddf17bfbe5040565cc4e4bec148bd16d41720474da8fb74a15a756a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/console"

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
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}/kics scan -p #{testpath}")
      Results Summary:
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end