class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.6.1",
      revision: "9a5419522817cccf323b39798ccf6d202b518943"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7521ebd6195a85c5799fa40f68fcaca4bae89b5ab515713ecdcd3266f425c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b7521ebd6195a85c5799fa40f68fcaca4bae89b5ab515713ecdcd3266f425c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b7521ebd6195a85c5799fa40f68fcaca4bae89b5ab515713ecdcd3266f425c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0039cebcd1e02d294dec27b8a75d2263471531c3deec9183ade58728deea369d"
    sha256 cellar: :any_skip_relocation, ventura:       "0039cebcd1e02d294dec27b8a75d2263471531c3deec9183ade58728deea369d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e54e1330818f1d5b3a7e7abad577d21d858b82d6a206be9d44729d45babb320a"
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