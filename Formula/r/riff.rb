class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.28.0.tar.gz"
  sha256 "4a4cec6432e61955a5c88808b11782191361e4c74b771ad4bc2b0d5d3201e40e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da42f58a195dc688403771356d37174787a40ce595c9802c5c79ccaded1e0266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92499ba81e597fdea1a8ad9c01dbd6aedeb277525cacb4de82999be1d7c00119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bfc0daa896bcfcb331880fd8dd8fa2f06a39d959d9214aba9619331e460b2f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "173925a9f97ba03bc8445a78909cb40e095a6992b4b46a6a8e9054c919fe8e57"
    sha256 cellar: :any_skip_relocation, ventura:        "1d272aab0dd506b89bb1a372307d5c438ff0b06dae0bcbb21d0d2515c9ed1b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "5b96fa7679e8d576a2cfa2a847de821cbd9052382cecd184047d99c6cda00b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfdf0bc215c9048ebfd964f93ea8296ee5834e8b470df53ffebfa050190a76f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end