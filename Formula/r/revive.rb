class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.7.0",
      revision: "8ece20b0789c517bd3a6742db0daa4dd5928146d"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4163b44b9a964351529229eaa1e65fd0f0927bbecc518d6f427fba4ec61e0b8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4163b44b9a964351529229eaa1e65fd0f0927bbecc518d6f427fba4ec61e0b8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4163b44b9a964351529229eaa1e65fd0f0927bbecc518d6f427fba4ec61e0b8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "46a4cb2b92f0dd68840b456143fca28cdf077e88ddd69fb95d924da19a616991"
    sha256 cellar: :any_skip_relocation, ventura:       "46a4cb2b92f0dd68840b456143fca28cdf077e88ddd69fb95d924da19a616991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7325d8b3d0a06b9913e646d4022bde6b834bb6f5e9ae4802204e86a46be958f8"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.commgechevrevivecli.commit=#{Utils.git_head}
      -X github.commgechevrevivecli.date=#{time.iso8601}
      -X github.commgechevrevivecli.builtBy=#{tap.user}
    ]
    ldflags << "-X github.commgechevrevivecli.version=#{version}" unless build.head?

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}revive -version")

    (testpath"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    GO

    system "go", "mod", "init", "brewtest"
    output = shell_output("#{bin}revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end