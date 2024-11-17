class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.5.1",
      revision: "3378f7033b4c26c7fb987a539ddb4bad6e88b5d7"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c92d60fe4dcfd7bf518a0fa433342f29aef6fdd5105203fbc714cbc4ca85e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c92d60fe4dcfd7bf518a0fa433342f29aef6fdd5105203fbc714cbc4ca85e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86c92d60fe4dcfd7bf518a0fa433342f29aef6fdd5105203fbc714cbc4ca85e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "dadea83cdd5c56c13725d30dbdd4e91b8fbb58a6afbd591c0448701d84bfa3fd"
    sha256 cellar: :any_skip_relocation, ventura:       "dadea83cdd5c56c13725d30dbdd4e91b8fbb58a6afbd591c0448701d84bfa3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bb1fbbeeb2e52e195c2a2dbd1c3093524a29df1e57ef0b0d7aecbca94c5b35"
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