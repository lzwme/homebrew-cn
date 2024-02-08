class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https:github.comgolangvuln"
  url "https:github.comgolangvulnarchiverefstagsv1.0.4.tar.gz"
  sha256 "11fc5678f7d1d838b4dd38032baf32cd244d029dbe6a4a3e7d88a5e7ccdaf4f0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d1b5d0eef56b2d195c0585e69cab89a5b24912bcb1ce9f47c7a043c095b9510"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac9cc9ed18cee963745e0396ad6c0c9e77f9b3191a6a2b2e6bc0c35ed09b8214"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13623590d16e6bd2d6964764af31d06b1565ef54c4052a98e565f542a837c583"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cb6057873daebb6e63370eec38bc02b865f621aa5b37b430c9d139ce0c17550"
    sha256 cellar: :any_skip_relocation, ventura:        "cb328e4427623355a2fa90847987f0a2d672d5bc9f40ec67a68775705b63522e"
    sha256 cellar: :any_skip_relocation, monterey:       "e3f397e097e19a5da47ba29d734464c7e70a04ff0810d0c1440ecf16932be9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69359c2a41899bc21b1006529ed00680b80eca662160d60588b316a0a988b742"
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