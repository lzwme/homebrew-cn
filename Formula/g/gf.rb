class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.8.0.tar.gz"
  sha256 "a40d3644999a68e043c3a3ce57c616df6c02680825b3ce1307c7ffc50b3a4d62"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "badbdc4091d9623dc4b8569c5660c9874658c3fcbbf2ace4b2f4ab3b15cfe21d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "badbdc4091d9623dc4b8569c5660c9874658c3fcbbf2ace4b2f4ab3b15cfe21d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "badbdc4091d9623dc4b8569c5660c9874658c3fcbbf2ace4b2f4ab3b15cfe21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c03f76d24265926e61fdc688c95824f4e59a33ce7561a143e07ed9dc57bdfd"
    sha256 cellar: :any_skip_relocation, ventura:       "68c03f76d24265926e61fdc688c95824f4e59a33ce7561a143e07ed9dc57bdfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c100e7af085e9e7f73ac486a64c7c044df658e816e92018844537cd4370b8693"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmdgf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end