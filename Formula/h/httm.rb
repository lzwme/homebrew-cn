class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.30.4.tar.gz"
  sha256 "35cc5666ad18251d35ac51a1aa8643f03a61f8609c3855820f6578ceed214515"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0d6c420f009737db36d18aa44a09ae9d17d5276fe5a6e9eb3fe1ac75290a90e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f9959b9c26828f662848237c99eefda15707cc97136389797843b864d87b08e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45993b267dacb99704bc424da044be5684c687d6245a0d51cda7b7e11c9d547f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b151ff87a603a9a78d9ca45b19dd4456e234febb3dcab32e17e789bbb5af14c1"
    sha256 cellar: :any_skip_relocation, ventura:        "0170b85f38972acbd126df1ed4d09551cdd6a40d4e486e72bd0f6d3861931ea0"
    sha256 cellar: :any_skip_relocation, monterey:       "20aa103d7768f004cb2315e293982b8df6f78d5d1b51912422e9abc8b7ed538e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54096d32907137c846844d1cf68f9308d23b133ee94f805cdff0fd6777a4bae2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end