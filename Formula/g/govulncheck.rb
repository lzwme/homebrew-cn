class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://ghfast.top/https://github.com/golang/vuln/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4fb7f0204b7e039f550d8938b714c5218d870694895585e0e19b2c0c4700e4c7"
  license "BSD-3-Clause"
  head "https://github.com/golang/vuln.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e62eb046e1114e5c2f468b08e5abedabd46a8cac1fbbc37ac78839caacdc825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e62eb046e1114e5c2f468b08e5abedabd46a8cac1fbbc37ac78839caacdc825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e62eb046e1114e5c2f468b08e5abedabd46a8cac1fbbc37ac78839caacdc825"
    sha256 cellar: :any_skip_relocation, sonoma:        "585cc24d6eee122b3606f73baf0b5f277449d9bf1f7a4e405b560ead7c501488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "069408f46c164da7cd5ec752efceda32b824de244dad7a63ba0141e5771c9f78"
    sha256 cellar: :any,                 x86_64_linux:  "f24b98bac8d774c0722bbfa5068db08ae0f01b96f824557f03294b808bab893d"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~GO
        package main

        func main() {}
      GO

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end