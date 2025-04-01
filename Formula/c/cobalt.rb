class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https:cobalt-org.github.io"
  url "https:github.comcobalt-orgcobalt.rsarchiverefstagsv0.19.9.tar.gz"
  sha256 "6d079f3ae89f25e44b062478264f9c3e1ec653ef408d36ccc97c05f65557eddc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37024da348dccb166b7f5a18c43ab53640b70ba11e4c507e206dd7ae372f67d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9799b1fbf9c77a3c36e05e05cd23d4569e50c7e2e888b3c7246799a00bc5d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "644063e005f92e76748b8a7ef84a7922a70f0c2f22817f5bffbaae51452eecf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d613b05af168a2d7ca903b7e4c1c813f6db1f355238083672eb42f0fb6fb2125"
    sha256 cellar: :any_skip_relocation, ventura:       "6346a930b3ab0e60026e3297ecb5ef329c204514b784ea92d5f34377fb662b51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f81017aa402bb252901db0b017eb64683a020401c8a0a7ef07b258544c3ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3988df028523a024ffa6d583d5d8faff649c3bf6db43d8e6bc56e859e028b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"cobalt", "init"
    system bin"cobalt", "build"
    assert_path_exists testpath"_siteindex.html"
  end
end