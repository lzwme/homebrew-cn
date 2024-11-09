class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.5.0",
      revision: "78c3a6c363edb5757ca829c9befa25bf75ac8bfc"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840a93760ae4e039605f758fee4669d18fab66d9699f50547c2307cb3ac71608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840a93760ae4e039605f758fee4669d18fab66d9699f50547c2307cb3ac71608"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "840a93760ae4e039605f758fee4669d18fab66d9699f50547c2307cb3ac71608"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc6f9970dc29e70e958406786463171261cc7f5f195eb6190143acc11695e8e"
    sha256 cellar: :any_skip_relocation, ventura:       "6dc6f9970dc29e70e958406786463171261cc7f5f195eb6190143acc11695e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60bcb8e59fed35925a46042ef9d3572845dae8c93bf5aaf090b678db1307cac5"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    ldflags << "-X main.version=#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
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