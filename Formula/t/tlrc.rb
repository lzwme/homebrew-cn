class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://github.com/tldr-pages/tlrc"
  url "https://ghproxy.com/https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "418d8f66d77bb01917b673a7dd7a54d58c2f8f297c0c6af5168c8d8b21effafc"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d361cc0f22b467a76ec29c888110c866b0895aa073924c9f459700be421fc80b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1b925d808e9183d3283f5249c8e9218959b0b0a5bcad7e98499a9784862f056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10794ed1130581b4e00dfc7dcfcc4c613eb8201873f7f22e55b945ed7b60005e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fe4bf3f0f965ba59619fdc364e7d588569a34a001f75cbdca7a14c550c0913d"
    sha256 cellar: :any_skip_relocation, ventura:        "69cef06e13edcf0aa8c5a085367471974e0381b99bd085f8628628cbde9ebc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "fdac5ff55164f9f9c9d5389ca08ce046031d015c1361ce6395091eace27ba3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72f78bf8c9d6a6fbcf22a37e2621d3b60e3d25fe548b49213458f00006bbdb7"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    ENV["COMPLETION_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "tldr.bash" => "tldr"
    zsh_completion.install "_tldr"
    fish_completion.install "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end