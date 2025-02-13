class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https:go-critic.com"
  url "https:github.comgo-criticgo-criticarchiverefstagsv0.12.0.tar.gz"
  sha256 "e981f7135bd0a21de3e94c05f5d393e6cf8c499c86251c94b1b9b11e9dcce153"
  license "MIT"
  head "https:github.comgo-criticgo-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e20f1f03c0ea8130dc3e4b2f5ae63c04a1f06bd7bd1eba4a73d54b9177b8c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e20f1f03c0ea8130dc3e4b2f5ae63c04a1f06bd7bd1eba4a73d54b9177b8c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71e20f1f03c0ea8130dc3e4b2f5ae63c04a1f06bd7bd1eba4a73d54b9177b8c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "345050ba8932fb0b2ff4fbf8829a85e2132ec7c758749ede1827f58a06d93308"
    sha256 cellar: :any_skip_relocation, ventura:       "345050ba8932fb0b2ff4fbf8829a85e2132ec7c758749ede1827f58a06d93308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f56fa0256d325890f1a53f5cc1339ab2c0b1547259df4e12030d649a939397"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags:, output: bin"gocritic"), ".cmdgocritic"
  end

  test do
    (testpath"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output = shell_output("#{bin}gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end