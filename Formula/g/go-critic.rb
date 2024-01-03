class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https:go-critic.com"
  url "https:github.comgo-criticgo-criticarchiverefstagsv0.11.0.tar.gz"
  sha256 "70ad71a24b0c2932b6b038518d61c2d645707bb904683572f8f1c101e0d1038e"
  license "MIT"
  head "https:github.comgo-criticgo-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f968bf0a2b6f63a79de6b07fdc664cb6401ae4b0415a59958719bee73bc897de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f968bf0a2b6f63a79de6b07fdc664cb6401ae4b0415a59958719bee73bc897de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f968bf0a2b6f63a79de6b07fdc664cb6401ae4b0415a59958719bee73bc897de"
    sha256 cellar: :any_skip_relocation, sonoma:         "26071c96ed52c8e92c6af5cc529d5c629e34888b7812150d2d4c61d4b471b360"
    sha256 cellar: :any_skip_relocation, ventura:        "26071c96ed52c8e92c6af5cc529d5c629e34888b7812150d2d4c61d4b471b360"
    sha256 cellar: :any_skip_relocation, monterey:       "26071c96ed52c8e92c6af5cc529d5c629e34888b7812150d2d4c61d4b471b360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f91a611a4409b27384fb54f8cfea863336a5c490132da7b368dd252946be197"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"gocritic"), ".cmdgocritic"
  end

  test do
    (testpath"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    EOS

    output = shell_output("#{bin}gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end