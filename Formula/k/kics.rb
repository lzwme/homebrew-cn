class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghfast.top/https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.12.tar.gz"
  sha256 "b0ed31d1a5055fa52fb346beb309c3084794219ad38400aee5c17e61046ac5ae"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bec084a47639c5e1ab52fb7c3f888046a8e5cdd9a2ad1828417effb83e9f341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204c25cecdb2786bfd4c8ff81914a0d4a0ffb46f83a58b44595c57f4fe80ea6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e07652e6b34c67c63d3738930cffd5d5552d7f0b45c720205697733111768ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5792231bf79dffb8262d86a2155f04a395df7b26c361978434fb3b4253710a3"
    sha256 cellar: :any_skip_relocation, ventura:       "0fb81927e8c26bc75e8f675b712684c50c7f0a092e177a8a81aba36190213060"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b1a51ab3231f66d7005d074bb25f9069947e42e8d1efbc4a34789f42973277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43bca63831657c7a21180208c1d5edc57fead2e8edb8e19d674c5f835402c81f"
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