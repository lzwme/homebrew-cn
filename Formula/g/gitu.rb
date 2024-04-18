class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.17.1.tar.gz"
  sha256 "23f925ec6450c4211aa72093cdb96ca17c768553390573b36671309497d996f2"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7358430f459404d6231bd1accbd6d078f819c2c2beb8dbe59049c3fbcaaf8ff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66eb6187ba28a2a382ffaa7f45d6ba96645f24989aff3ad413b5d1710bd713f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a213df0dcf5f37c1a277f8e4f4e33f48bc0c830958081b4c837a365a39eb68c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b16c939aa3d7818e230cde1d62d3a64070f3a4bf837e20fa49aaafeccebb70c8"
    sha256 cellar: :any_skip_relocation, ventura:        "3f94210074a83b80fb89af19bbc75732b92efedfb09ed1329f44693a76adf833"
    sha256 cellar: :any_skip_relocation, monterey:       "0637ebe4d3763340ef6e6821f93800f3e324854622ec94016a0f16196d619dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e34fec34e18bb800b6df4800b6ae43bf7dcffc1d5ef52bce873d987d4fbe7d"
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