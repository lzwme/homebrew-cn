class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.18.4.tar.gz"
  sha256 "cef012fcdb53873b8251ed11ffa99a8429e3d1fca49dbc1459d651c671cb2d85"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57862d1847266c45d1b01abf6bb2684b2639c68ffd969b0f683ab160c78d6c21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c18b7645d32d92e78aa6b918e3ea28c2a4e481b4b36c459c7ec636de19adf5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8da2d29955049d4dca945462cfef5bf6218266accbf5c7871891c01c6f72cd8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "49feb1fc851b830f94dafc3ef39142347b72442fec9e08c0bd324a8117667e16"
    sha256 cellar: :any_skip_relocation, ventura:        "726ff42779ebef376adf6528eaa746d2666cff4baf5fd474419f6ea3dae339a6"
    sha256 cellar: :any_skip_relocation, monterey:       "336d6b1df649ee976bfe3812470f8cc275a46af6c6a65bba8850d3ac79bbf737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b561f5e4df14014fce58b6380f9b05b110bdd3d5353b01e5334c317665f5c384"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end