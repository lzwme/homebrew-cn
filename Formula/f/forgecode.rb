class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.13.tar.gz"
  sha256 "9934f1e340d50936e6e09f5ca52b7989d8a8a6e9201204ef575cd01966189878"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e2c0702070c11d796def5dd88581f041e09512b6de4905decb30aaf2460b14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a076bdf1f9eb1da29a4a2c09946da69452561dcedc9032e501bf9e59be75b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d66ffe4c0b084e4823da437c4267a1e922634bd29895fd58afacbf04efb4738"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ff3b428ccedc7e77f03a322817dd4cfcc1f9f6403accb123143f02f402d4eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79f92dcedf1af1aaea1cdfd81715b6f8762b579d7dfb7663f29b200a788ef0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b377adcdfc45ac31b2aca037c4759944d37f6c0524a7224ec8edab602f6c621d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end