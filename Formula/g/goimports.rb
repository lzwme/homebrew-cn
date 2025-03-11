class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https:pkg.go.devgolang.orgxtoolscmdgoimports"
  url "https:github.comgolangtoolsarchiverefstagsv0.31.0.tar.gz"
  sha256 "e5d74f1e63a1ee669e75e76668cea1b110e2b9d19c67710f60939ee38070a5a7"
  license "BSD-3-Clause"
  head "https:github.comgolangtools.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca73b64411c476974011e8e7d215c01a777a21b4e40a796c55fe4493d700ae08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca73b64411c476974011e8e7d215c01a777a21b4e40a796c55fe4493d700ae08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca73b64411c476974011e8e7d215c01a777a21b4e40a796c55fe4493d700ae08"
    sha256 cellar: :any_skip_relocation, sonoma:        "65e81110176181a0e58ebac7c96fab37c2d4bf31b0f11db4ea9b553a0e95574f"
    sha256 cellar: :any_skip_relocation, ventura:       "65e81110176181a0e58ebac7c96fab37c2d4bf31b0f11db4ea9b553a0e95574f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c270a1a30c4f64666550eb981628385cd10d83c45975a8b477ac69a6c1b87c8"
  end

  depends_on "go"

  def install
    chdir "cmdgoimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(\+import "fmt", shell_output("#{bin}goimports -d #{testpath}main.go"))
  end
end