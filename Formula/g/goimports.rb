class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://ghfast.top/https://github.com/golang/tools/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "ed3063f864a4c3e12f02dc4553d087b22b3b5f09f881e977613772e3f2324ab9"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f11f454ad19955387a7cfc1c44fb36df85617ca3936dc0d560f052fc97c36a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f11f454ad19955387a7cfc1c44fb36df85617ca3936dc0d560f052fc97c36a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40f11f454ad19955387a7cfc1c44fb36df85617ca3936dc0d560f052fc97c36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c154610eea3e2b790e73ccf6f9f897f880d13bc7cf5f585ed66ad9c424af3e6"
    sha256 cellar: :any_skip_relocation, ventura:       "4c154610eea3e2b790e73ccf6f9f897f880d13bc7cf5f585ed66ad9c424af3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "042d4c7f00027f1fef79d057cde028d6cecbff54454ac4794e4c49c809fd82e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcb5c1ada6d630e581d5ead881912d3534c9b6e364a9347be5e12d20c61d3b29"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(/\+import "fmt"/, shell_output("#{bin}/goimports -d #{testpath}/main.go"))
  end
end