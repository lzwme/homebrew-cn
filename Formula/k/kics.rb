class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https:kics.io"
  url "https:github.comCheckmarxkicsarchiverefstagsv2.1.10.tar.gz"
  sha256 "f43dad94a7b81142d32cac827fdfe813d771c6af6d290c87a653db6341fff87e"
  license "Apache-2.0"
  head "https:github.comCheckmarxkics.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65609cf9e0693972fd959dd2f170be5425b27254438fd4baed485b8942e00cf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9452baea3f06cfe3eb562f36c4f7a6239922e3ab53a2b93175bf2517bfd05ab1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3f202abcc3da58c47406e6af5c1473a133254f62a880e104fd080aab67ec1e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d93dd1fa77bf56da5680e951ef6a2ba293ea5d594a76e7886789c66f6a2cf2d8"
    sha256 cellar: :any_skip_relocation, ventura:       "cad58bf2c5e936ead8e3d44ba4887bd2246cff4e8b9f6dd2a311cdf58818d914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75bce73faa0c6eadb256b4de657b9cfb76bf1e6bf8433d13ea6feab2d60ed4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc8a3a2d65023f75d2ae8d61c4e800142672875780fc0fde5b28045eb0eb44f"
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