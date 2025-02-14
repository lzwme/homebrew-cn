class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https:go-critic.com"
  url "https:github.comgo-criticgo-criticarchiverefstagsv0.12.0.tar.gz"
  sha256 "e981f7135bd0a21de3e94c05f5d393e6cf8c499c86251c94b1b9b11e9dcce153"
  license "MIT"
  revision 1
  head "https:github.comgo-criticgo-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f7971b219070c3ed47764115b9cd3106fbc57eb303898ee1a8c6352c1f40bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f7971b219070c3ed47764115b9cd3106fbc57eb303898ee1a8c6352c1f40bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09f7971b219070c3ed47764115b9cd3106fbc57eb303898ee1a8c6352c1f40bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0effe3e1a941ce554259f64fda6556d38fd3e14de8ad28e3e511120345469c8"
    sha256 cellar: :any_skip_relocation, ventura:       "a0effe3e1a941ce554259f64fda6556d38fd3e14de8ad28e3e511120345469c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0f4be399a039a0de00ab26a5bbd9dbf52e4977483251d3a3ffdfec9a7e1aa7"
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