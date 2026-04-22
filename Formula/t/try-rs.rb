class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "01b181b196b4cfd90713e266797611b9e44a5407ec7e5bb4f3adae68b9fec31a"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ada2d09b59718eb98bdc333c62a35b8c5655e73a9817a2c7578924e3cb92b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4714ed1de1996300b296803a84ee81a987b909bec370e6171f37a4470cf08c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "924e63845245315fc1321c4d0ee0e19289d323fba4f5b85a47c9624553d02776"
    sha256 cellar: :any_skip_relocation, sonoma:        "58d4541c1a7e5599290fae02212593b4a0bb6c59c1751ff6d527b55864ee9207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a675f9c85755959201d4514f6188927c97c5844bbcdcc1ba0fdbc5d4a0762ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b2628bf7b6e746422907479d32272c68ac41392d8e2f6a64a6e758d6868903"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end