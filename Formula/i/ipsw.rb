class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.618.tar.gz"
  sha256 "97cf264c0e58469e86216a08077c544d37fdb757b8941b3c634bee1f94abc8d0"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "353be20a125701c2fa059f6715ad543be88167699587a3da67e99c222b9a2cb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c6918e167706c1618cec63a4a157f3092a961f5a6f62769f9413d8c4d999cd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5e7cec81355cc178e23cce5518117cbe1c4915304adea4aa9ee277317543636"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ebcfb81f5316d6a6e905724899172283dc851d0593912f09cfd03410bcbd5c"
    sha256 cellar: :any_skip_relocation, ventura:       "e14c6b07b8531359b123dee42a069c37e9d25b3a25ecb3b312a16ed4eaf091ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c1ec25d7552ea66fb9ef4b8e72ec3cab9f0dad3dc68255102d3b65851ab5cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d78fbb8d8ebe17264f571d81f2ae2639fd53923cf6d5a218617deb8f8ddf4d3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end