class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "9d91468a62f688c638d961f5f1b8c0ec991fd20a2ee5d74e68c5a69f23c31aca"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d54add6c78a2b7c3acc51effa06e723d3ef90ba268db3c92430d808df0cc2df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003988adafa2b58be40bd94286bf439d6bd61a518ef207e679aad2d1b3d7d718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c2c438559f79c7b3388754b57365851243d4cfd318d2025f61f793e723ef3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "24645496f1ec512b1ab797e916c743597388679eb38410890c3da28c5532992c"
    sha256 cellar: :any,                 arm64_linux:   "5643ee5d3f7cb632c766e876b8a9258f26a2a32479933525625c367eaddfda96"
    sha256 cellar: :any,                 x86_64_linux:  "27635ee3fc7cd04593415fd922cde18a16cdc9703f5584960d1c1cee211ae94e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end