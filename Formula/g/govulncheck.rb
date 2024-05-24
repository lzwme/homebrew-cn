class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https:github.comgolangvuln"
  url "https:github.comgolangvulnarchiverefstagsv1.1.1.tar.gz"
  sha256 "a1c1c287dfacd4b3c40b369a11d67be968796d481cbb35539100ae944a7045fa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6168a3ec46db9a431e72b25c0ea0033b71e3c0ba8dd0614d0aebceb1e7383ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f977516721443ce4e650fc3a01ef506b314d7ce331eaf7c9c86bb782e292aa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae61e186cfcdef4dc3c8a56ac6cb94e0be45cff03fc31f2c1252d75fcf99f827"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc52656de21f8bc701031e0502d212eddd276073c3e10e7be7801108734c1417"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e24fca4f0fe94f0d73dfccc28bc2aa8c9d782e7d8d8606565043849c878c94"
    sha256 cellar: :any_skip_relocation, monterey:       "639efc242745af5c114022a1e173a116cccfa87e3350c99f2d4d713a134ee7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7628fc86bc5d3460cd6e1cf8ae4200f2a3d60a410e3d8fc56e32bff5c0f41ffc"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgovulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath"brewtestmain.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}govulncheck ....")
      assert_match "No vulnerabilities found.", output
    end
  end
end