class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https:github.comJuliaLangjuliaup"
  url "https:github.comJuliaLangjuliauparchiverefstagsv1.17.9.tar.gz"
  sha256 "3072a404573e0e64a7d586f32ac1ba5fcbacd142e2050f7a3b452d1697181f4f"
  license "MIT"
  head "https:github.comJuliaLangjuliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b240f99f2c8e365f8e267dce4bb22ef1979be1af5438e5263d7df1e7099ac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f3764a70938e92d3f8f54190e596f2e18f05682bacec6e2b2c15fe37ece47e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "876d2427f907bb10fe029d38b9085358443261be97338707116a7c69040ee0ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "5efa5e4d82a2de00ed429ede36207567d312392f189ea3988bdcac389a898d07"
    sha256 cellar: :any_skip_relocation, ventura:       "afdb02a2dfb015cdb945a51601a04e98b57d2b6cf5fb8c791faca94244eff458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9200cdf9861597d863762e06f1186b7b3c99dbde24476e0bbb1728381b659ff3"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}juliaup status").lines.first.strip
  end
end