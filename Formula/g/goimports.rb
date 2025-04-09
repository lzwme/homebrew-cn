class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https:pkg.go.devgolang.orgxtoolscmdgoimports"
  url "https:github.comgolangtoolsarchiverefstagsv0.32.0.tar.gz"
  sha256 "f2b22107aaea83bbcc4a34c86e4331dda035f71e72bdbc057c32ce7072a17c5b"
  license "BSD-3-Clause"
  head "https:github.comgolangtools.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "447aff30ac81edfdf95f5131443b635fa92d297237b0eabcff71e80d7e332bd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447aff30ac81edfdf95f5131443b635fa92d297237b0eabcff71e80d7e332bd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "447aff30ac81edfdf95f5131443b635fa92d297237b0eabcff71e80d7e332bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae3d608023a85cabc2ba50119d19cbef9dd5f655ab392b3ad9c300329a7c898b"
    sha256 cellar: :any_skip_relocation, ventura:       "ae3d608023a85cabc2ba50119d19cbef9dd5f655ab392b3ad9c300329a7c898b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c5d92127d45963cf72dec6dea6f3cca9bb9eabecd1c76656658756abb6d101"
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