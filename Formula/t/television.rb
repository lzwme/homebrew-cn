class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.15.1.tar.gz"
  sha256 "1e1f9d5c7a4a22b20ce8cf26f3ee4f72fb1361368d759063ea7ff611979be0fb"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ca690a1ee7a992bc4e37de8216c5aee84f013ff76823276b60622072eeac9dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97274ec207798bd3e452ca39f576965f6eb665c642f63f505dc316d948133aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7d08ca16af75e6bcc177fb318b513117daebfb7e5f7e5032e439d3d940eac10"
    sha256 cellar: :any_skip_relocation, sonoma:        "125ea54a615d4c5ed09ea267cafa31601508e74d17335cd11bc8548371d6be8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b11a0150c967cf022492d05f6436df3d28bda2f8603029e85985da8a9ef494df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c691dbbad89be03200f366d038866c9fd5bf1cca720bae52f2a153fabb156058"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end