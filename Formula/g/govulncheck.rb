class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https:github.comgolangvuln"
  url "https:github.comgolangvulnarchiverefstagsv1.0.3.tar.gz"
  sha256 "ed4e87836aecad124a03f1f485577c05ba6fde892e9964117788d85c423ad47b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1858f31837ecdb244cecede7fbba4938bf15762fb3c3c6b1e4d21fe99f8fe561"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "648795e4f3b70ddb66857bbc0662490b452671989b956d3f77fd69fde93eea6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5350e089a083d51b394f94eee44ca2b5a301a9bd8654e3ae62aab698d4eb7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "04dee33cf2d265f610247f8a15ab3de9efb0e2897373585a4decd83fab404e04"
    sha256 cellar: :any_skip_relocation, ventura:        "10029b56623cc0e273649703001eb8197c0076157f942341531846a3bceed4f0"
    sha256 cellar: :any_skip_relocation, monterey:       "8c285f4b6847ecba02e93c074bcbcf061c9f89375057d0399e960c2a22215fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eea8a05bc50ffeff5e95bcab8a03abf7703babefbd1a809616332c59ef96c35"
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