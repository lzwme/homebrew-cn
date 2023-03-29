class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://ghproxy.com/https://github.com/octobuild/octobuild/archive/refs/tags/0.5.4.tar.gz"
  sha256 "f532639cb5711c4127093f8cd60e59935ac689905470bd7d0050ef613b505cf7"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30420ff946bbf987041478f0216d0db8308bef002c746eaf18d5a0c873ad4070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b27a33127a948a8ce433e832ebd204e577f6c79481ff6fe4e1d7c9dd749a7201"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab4f357fd328045ce649bbb0cc84b15e08920488e9bf50ec4b3f91aa78d9ae67"
    sha256 cellar: :any_skip_relocation, ventura:        "7748353150992553d04daf806f4c69f08361d9bb267c3020d9b7fb60b8653716"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc2e634856489197f391db3ee0efc5edf8015759ab2de6809245612c0218366"
    sha256 cellar: :any_skip_relocation, big_sur:        "78aba9b34ff522c3ed859be3c4a45ce139a29368e46440e29e874b47d9e95306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10801a753f04435bd8b39ca423fa36b122b1f3e72942d18a94cfd4649670cd00"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end