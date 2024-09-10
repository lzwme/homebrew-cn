class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.7.3.tar.gz"
  sha256 "f7d9dcf3b19045ba4a69c5b4c2aec03094832f414a66edd84d46ae6079f9d798"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d81badfdb5b557c4f83ab6b7995c004e544c4a14e8ead3977017e06a3d12be0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81badfdb5b557c4f83ab6b7995c004e544c4a14e8ead3977017e06a3d12be0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81badfdb5b557c4f83ab6b7995c004e544c4a14e8ead3977017e06a3d12be0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7999c73f62f674a420360fbf29e88bfd02d0d811e9de3db831427fb28a28cb75"
    sha256 cellar: :any_skip_relocation, ventura:        "7999c73f62f674a420360fbf29e88bfd02d0d811e9de3db831427fb28a28cb75"
    sha256 cellar: :any_skip_relocation, monterey:       "7999c73f62f674a420360fbf29e88bfd02d0d811e9de3db831427fb28a28cb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf366675f68212485ee3a6aa71b74d2e40ee85f6c1e74b481ecf6510ed7f431"
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