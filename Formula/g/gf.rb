class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.8.2.tar.gz"
  sha256 "5094a638133e998d569c223fcdbf68249d05e22a1b19a7f5f9b2e84576117d2b"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100a140d9ec2669654b27a14294b3085444aa6cf6980ba97e4ebf67fa11a0459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "100a140d9ec2669654b27a14294b3085444aa6cf6980ba97e4ebf67fa11a0459"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "100a140d9ec2669654b27a14294b3085444aa6cf6980ba97e4ebf67fa11a0459"
    sha256 cellar: :any_skip_relocation, sonoma:        "af7483153b6eb085df3e88e1e09af717d3bb4f983ffab10edf3cce67db276109"
    sha256 cellar: :any_skip_relocation, ventura:       "af7483153b6eb085df3e88e1e09af717d3bb4f983ffab10edf3cce67db276109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a488c009cf61a1fdd385973e23903e1853fd009d73dfe02fc722e849606531"
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