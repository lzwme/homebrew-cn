class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghfast.top/https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.15.tar.gz"
  sha256 "4366ce559106eeafe217dce02127b1a28471b567acbe0d5c8a546ebb011a804c"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "409b5e5d46ada6f3b58ad8ab695770080e4ea8be8e3a23547cea5c150f054ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fab44e197e0a7ae5cd7ce911b84acb7c4cfb8e37c199ac188b5db9919ccdbf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b9b937a3a610e6b9ef0f8f3cf86b000684ada805d70c9121b617a61532320cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc413d0bb027bbfdfe230ed687a55d7fb358f12c3b9b3729e2a2f22b0067036e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75031a694f0cbcedff32ac1e1604878a4f90155ff67fb33a15164ee59ac19392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14de0edfe88cbff35b632f213d806bf645ba3cd1dcf57f41865180d325dffe6c"
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