class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.6.2.tar.gz"
  sha256 "b264d277649504dcc4a26728be291f6b02aa4ba7dfddcb3c87029ab6e4739e1b"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5b4ed839e9ab9fa03f05f2b854a7edfd429b0e87bd1bc61e2790135524f4bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ce84d236a72e7fc25ed8fb137943755ef2f001b211e70d318d037912a2bf7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ed3a208b0b9e4e5d49dfd80a3a996bba729ed0b85a50e013f6533e8d650a3a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5bd1d51b0ceb8f4b7308e50fae9b0ae020d768cba880de0f001fbffb6ad155b"
    sha256 cellar: :any_skip_relocation, ventura:        "bd31b6509f3a19aa1660b65faa14fc4d212f73d4b456eb6620e22e97b6f5cb77"
    sha256 cellar: :any_skip_relocation, monterey:       "82042d01f3bb249f93bbf7d9720cb521b3df4aa25100cf4aabc520c79f71ff0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e25ff3cbb7b389b7f14477324356e0a4c9c0a6e772b6a00ff459a1e4d36c9a20"
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