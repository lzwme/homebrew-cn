class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://ghfast.top/https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.17.tar.gz"
  sha256 "83c347cd23a70a0ba2be5255435f16843e89e2c2563eac98a5732ad6265c6e5c"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dbd37c8d0181a803c03c597882b4691035f5e195c2757b4716e18e968afe2a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac1041b3818c303507de159eb57273c5878999faa193181a5547898115f05f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f7c03f8c1e021f92eadc19263a53c83168420d4630ff709c72b58664d5cdba"
    sha256 cellar: :any_skip_relocation, sonoma:        "380d655aee6e85c2dbb4c3f70406c86943e862f4fd12117c1dd84f5381aeb55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32018b74317511a26e91a9557d8cfdf9b1dbc1ad7987ba071e30895baa75189b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0c37224d09f7b9a596ad4ad5c1bd13f629d571018058421da74e62a2f4a2ce"
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