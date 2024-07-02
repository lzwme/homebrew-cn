class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https:kics.io"
  url "https:github.comCheckmarxkicsarchiverefstagsv2.1.1.tar.gz"
  sha256 "3768aac0eed89f001d35726b8664b340101937555cc2db37064a1cd8a3351f9e"
  license "Apache-2.0"
  head "https:github.comCheckmarxkics.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e030ff50e9975c048d5a45099debc31b7505f48783c171b1879d77bff52a36e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97e5fde68de5400bd823c4faa0ddfddade54409f618215fc1a86a12f4702a527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e6cbb55601ce13273b69e858abfe879ce1182f03d0b5598dd97b3f10d0b1c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "852b00d6f448adf21a9832418c1506764412d2777a673d8f246d36f725f4c5ae"
    sha256 cellar: :any_skip_relocation, ventura:        "47f68e7e1929c094472cc340288ff0d46323e70e713e11696a5fea33d1c3586e"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb88b66b217aac57148b200cdec1dd9cb910243df046b521b45e861e0222fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63c0f66b177f502558b03e3ecf41a7e6bfba9ac8cc3590b77ecbcb65ca55952"
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