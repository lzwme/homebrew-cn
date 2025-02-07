class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.5.0.tar.gz"
  sha256 "f12a8465255505179eb6fc1049ecbeea73ba0cf258ee9efdda8f2e74a8ccc903"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c018a9782bf1e3493e830c8be05756818e6c8ffdaac63f138628808a15fa89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff3ca74f6b60ae74099dd7f4b32e3cee677fc543a8bcdbdc4ecd4233cc31908"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a34f74609d5e5b67169534994bf641f6918af8d1a7f85cb0a327f22836bc2be"
    sha256 cellar: :any_skip_relocation, sonoma:        "6caddf264f768f9dc1922fb94c2881f1de6f81792d68a79a1b7c6ce18e850b44"
    sha256 cellar: :any_skip_relocation, ventura:       "95174c9a399ab9dc9119f3e16ac09db68e1ef7c858c57de2d418205aebe98dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a22353f19219c4ede7ce5d827edb1129990f7436a66d25d02f8d7d4505c4b56"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*yml, *yaml)", shell_output("#{bin}/mergiraf languages")
  end
end