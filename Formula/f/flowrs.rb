class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.13.3.tar.gz"
  sha256 "8245270e9b6a879ba5c645632b512eb6c468733cd21a2c13e41df15f87bf7d95"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d68e4b8360b843af55fd909fab48a08088dd0706fe7ad1a81f661bc13399193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6711e641bab51f51d069d7661bcf5a6857ab59559d69f6783253afdfe140de08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0da9ca0b99624561f70e4842fe37d98fd42fbf42259ba52c4735552cef49557"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ec74d2a99fb2e64ba6670209600270a62dca07d5915395bb8027730764effa"
    sha256 cellar: :any,                 arm64_linux:   "e28da6c6e63fc16895c449b6a5834db3cc949c6b38b2c9b1ada8585ac2361498"
    sha256 cellar: :any,                 x86_64_linux:  "62c0fb596b2e2bb53f17f0c476849bed960bc386970214391b455a2fad3c43e6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end