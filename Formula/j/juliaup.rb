class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https:github.comJuliaLangjuliaup"
  url "https:github.comJuliaLangjuliauparchiverefstagsv1.13.0.tar.gz"
  sha256 "2dc9a457e42432084dda423486b20e578f8c843a0314ef2677b05e843714ff3a"
  license "MIT"
  head "https:github.comJuliaLangjuliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0e5eef1dee95b24f36731d8cab3ee281c9a58d2b07764c623519f3f18dee4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e1893ea87adc0a2f6f7d3ccdcd5530d75df186d418babcf546a5032c43f474d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69948cef36cda78dd34085abdf0e6600d35ce7115b22d6e6c67fa9f618fb01e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9972180fcee045c7e8f93a1257b5b271e0c6356b006a5206935fe477958b4ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "ebed0af13b04c91fe004ea547ce1a9417ead8856d019c409221e5bc0ccc11014"
    sha256 cellar: :any_skip_relocation, monterey:       "eed169beb0e9ffb9498a715ca7808619693353b9a7179328812b3536530502cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753660cb0a61f28b5443b787dde5921058eef561b45e7099c79352d6680e08ba"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}juliaup status").lines.first.strip
  end
end