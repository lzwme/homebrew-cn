class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https:github.comgolangvuln"
  url "https:github.comgolangvulnarchiverefstagsv1.1.3.tar.gz"
  sha256 "9609756c03d8ce810a1a65434ad15d35213cf97414341644777308ae9753370e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad655601412ddfee98d2289933e2fe38c5cccb8ba554d7ce7fcc003e95d6f884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90aa19223f07fa0ea476ada254afa1c845066fde5a674f3e56d53ceb50517cd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c526398ae971660f1eb5e36bb99aa64737066640db64e28b9df6c83c10a8f52c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8470d67b8a4104464e6eeb4ad04fe5282c29db4e6df550b6dc644038d6599332"
    sha256 cellar: :any_skip_relocation, ventura:        "4c2a2dca23d0d282174acede6e0b715d256f4ff9e257f9e7e6c90092c8ebec82"
    sha256 cellar: :any_skip_relocation, monterey:       "d99d926005d69e82ab9c991e18542eb022dd0ce7d11b6d22666a70b2ca0c083d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806910d3d494bfbff8e51d67e8a919b7d9589703ef6f56b88d0aa7bca605e89f"
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