class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.8.0",
      revision: "9f5f957b33e3c39ce6944c3bfbb02caea179e43b"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d773e8d4a21f7479a4524fce0f4f0c822b57bdedac84dfc69e4979119d410e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d773e8d4a21f7479a4524fce0f4f0c822b57bdedac84dfc69e4979119d410e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49d773e8d4a21f7479a4524fce0f4f0c822b57bdedac84dfc69e4979119d410e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd38e7f67068e547c383ee82b7a54871979f43c5e4824f993b28c9817d174953"
    sha256 cellar: :any_skip_relocation, ventura:       "fd38e7f67068e547c383ee82b7a54871979f43c5e4824f993b28c9817d174953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66e89d174e60be1b6615abf0a0626bacb9ffefa1f9ff1b306b5739e380bc503"
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