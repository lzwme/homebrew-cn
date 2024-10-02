class Richgo < Formula
  desc "Enrich `go test` outputs with text decorations"
  homepage "https:github.comkyoh86richgo"
  url "https:github.comkyoh86richgoarchiverefstagsv0.3.12.tar.gz"
  sha256 "811db92c36818be053fa3950d40f8cca13912b8a4a9f54b82a63e2f112d2c4fe"
  license "MIT"
  head "https:github.comkyoh86richgo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "967353f6b2bfa1c35a96f76eb85b98d3e6ea91d8b424a2655e80ab957884591b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "967353f6b2bfa1c35a96f76eb85b98d3e6ea91d8b424a2655e80ab957884591b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "967353f6b2bfa1c35a96f76eb85b98d3e6ea91d8b424a2655e80ab957884591b"
    sha256 cellar: :any_skip_relocation, sonoma:        "31d3f488ac0adb8874295408a1ea9c56acfbf9a90484d90b3e34d76ffcf20927"
    sha256 cellar: :any_skip_relocation, ventura:       "31d3f488ac0adb8874295408a1ea9c56acfbf9a90484d90b3e34d76ffcf20927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da63b93248cf2292a4c287cc5973c39eded1d3c349ebfba315b3913883045d3c"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"go.mod").write <<~EOS
      module github.comHomebrewbrew-test

      go 1.21
    EOS

    (testpath"main.go").write <<~EOS
      package main

      import "fmt"

      func Hello() string {
        return "Hello, gotestsum."
      }

      func main() {
        fmt.Println(Hello())
      }
    EOS

    (testpath"main_test.go").write <<~EOS
      package main

      import "testing"

      func TestHello(t *testing.T) {
        got := Hello()
        want := "Hello, gotestsum."
        if got != want {
          t.Errorf("got %q, want %q", got, want)
        }
      }
    EOS

    output = shell_output("#{bin}richgo test ....")

    expected = if OS.mac?
      "PASS | github.comHomebrewbrew-test"
    else
      "ok  \tgithub.comHomebrewbrew-test"
    end
    assert_match expected, output
  end
end