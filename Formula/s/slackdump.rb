class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https:github.comrusqslackdump"
  url "https:github.comrusqslackdumparchiverefstagsv2.6.0.tar.gz"
  sha256 "794866c8c72c89a4f5cab3917c4ed4eba00928841e17e6082213eb9a4ffe7df0"
  license "GPL-3.0-only"
  head "https:github.comrusqslackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bffd112bc0726b9b5496a7a75f807be85ebb1c221c096ec14464ba08c984388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bffd112bc0726b9b5496a7a75f807be85ebb1c221c096ec14464ba08c984388"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bffd112bc0726b9b5496a7a75f807be85ebb1c221c096ec14464ba08c984388"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5d75f6440152103e83f240ac04ccbcd512371c21dbb7aa869b74bd20a27363e"
    sha256 cellar: :any_skip_relocation, ventura:       "e5d75f6440152103e83f240ac04ccbcd512371c21dbb7aa869b74bd20a27363e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc3593e8dd9f95fb20e6f7444d512082bfe12326cd33352f27213e8d44ba9af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdslackdump"
  end

  test do
    assert_match version.to_s, shell_output(bin"slackdump -V")

    assert_match "You have been logged out.", shell_output(bin"slackdump -auth-reset 2>&1")
  end
end