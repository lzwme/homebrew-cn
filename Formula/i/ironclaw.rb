class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "e8c2f5ee2c31e577ab27096865abd98736975a90b5ed7b40521a7ec8c94b8dd2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "staging"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172bbb7889be6272deca2604d64d1be4cd3049b8b46db34dcdf485e108d81f3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6278afc713f62a18a02c8d3f8c3ecef04c69cc4fc91c3e69ebf7365e2f4006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60064c828773052b1e203cf23cd23a3988ec8e7a7fe40e33b10dbf578d37ac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "38ba2b983796ebacb75fec1f34a1785f63bd5921e013b87dafe0b557efcc1dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d780f52a3193017719c8e169e4f4b0b62b1d79e2d7fa53c8dc5427b20c5f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bbdd313140032ecd0fac8dd12e60829a5793d10f5436892b0bf85929570b57"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end