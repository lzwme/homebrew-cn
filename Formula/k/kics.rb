class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https:kics.io"
  url "https:github.comCheckmarxkicsarchiverefstagsv2.1.8.tar.gz"
  sha256 "5d88e37d3f160b22f26cb60dd01b41ba64c29e670ca725291a6c164cdd79ce94"
  license "Apache-2.0"
  head "https:github.comCheckmarxkics.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b18424424ae34b9f5f4ef5febcb18c7fd6a68d6536c76b5e21eaddd30382926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01cdaf84c8da2589c9e3162148847a74e62d9fce4d447f1cbddb63cf55b1c17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0290c932619c1eb91077d227a9657fcb1c9f33ab02f43c231ac5ff089843e163"
    sha256 cellar: :any_skip_relocation, sonoma:        "e55e7d6672abbf0718ef97c8c7e87296551b3f9e0c18e734d7a5bd03c379b93f"
    sha256 cellar: :any_skip_relocation, ventura:       "f77af2a1fb4f2a51475e8a99c01b06909a5942a8a38adf5b3951ef3ca23eb554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b04a586207ef69160d14d1184e9c35d9fc074d01fbfe7de8449035a7abd375b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a442c04bb8998d1f99de21a462028733ace6888dd93eabb2405fe020ed50bb6a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comCheckmarxkicsv#{version.major}internalconstants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdconsole"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}assetsqueries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~.zshrc or ~.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}assetsqueries' >> ~.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare"assetsqueries"
    ENV["DISABLE_CRASH_REPORT"] = "0"
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}kics scan -p #{testpath}")
      Results Summary:
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}kics version")
  end
end