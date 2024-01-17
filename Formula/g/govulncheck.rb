class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https:github.comgolangvuln"
  url "https:github.comgolangvulnarchiverefstagsv1.0.2.tar.gz"
  sha256 "e5a38b9bd7aedc67f0cab6a9c90d0515041da2cea919fb2fb2351b94fe6bf29b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "830fd25e7815b8f8b679971491e8cb355ebe930cc7be20ee262f2edaea6c807c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95a60ccf89c8cc2145533703d29813ac4a342bbad15484ec517b74301d1ef140"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e24b52fed15160dd9c8650b77932ff4e5988dd9d1f692a7adaf2a8558143beb"
    sha256 cellar: :any_skip_relocation, sonoma:         "706aba05bb638e844247cd8a8b04e2d8bf366d11b96d5bcff0cfe8eb3a8b50af"
    sha256 cellar: :any_skip_relocation, ventura:        "e1193ac3cdb60fc7cbc2211e580ad720670a238f04560534009a3b1d979bab0f"
    sha256 cellar: :any_skip_relocation, monterey:       "975fd751bf5c58b79ab043072d6363e84458d31fac06003dc1d88441a228d28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef183d9d341050ca5d8aee5e57697daa077e4428774cd9f0542437b5cece4f40"
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