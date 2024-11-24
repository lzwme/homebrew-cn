class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.8.1.tar.gz"
  sha256 "a4fca9d3ef712d60d918d908c3e184eccacf0d9ab43ddf764c04d72717b4f890"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66286c5e779584cf45bff5380ce7d7bd0be7c2abde99dc08bbbf3b6858df0591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66286c5e779584cf45bff5380ce7d7bd0be7c2abde99dc08bbbf3b6858df0591"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66286c5e779584cf45bff5380ce7d7bd0be7c2abde99dc08bbbf3b6858df0591"
    sha256 cellar: :any_skip_relocation, sonoma:        "864b62d354179f635ad69a79c6f5e139ff95c4597520e502da1ceeaeb28a7321"
    sha256 cellar: :any_skip_relocation, ventura:       "864b62d354179f635ad69a79c6f5e139ff95c4597520e502da1ceeaeb28a7321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21932b7acfbc0e78f622859008d4844adc6bc651615ee9e17cbbbc8f97203f44"
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