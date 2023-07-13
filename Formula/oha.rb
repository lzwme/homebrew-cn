class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://ghproxy.com/https://github.com/hatoo/oha/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "53c1f56b0541e8d2c56be60972543da0141a2a1dda09128410bdb8e010adab6a"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bfed134b89b7e5b1d46920b78b420d3f336c3dad6bdaef68999d6dc552e79ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc1ccb9a903956594d5157f115404437f6f1757f5134c80fac04950799fafb9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2851a801cb77206c610faf98a40d7b2b1da079d23865e15b834c093ec8bf320"
    sha256 cellar: :any_skip_relocation, ventura:        "64354228dc0a3f2f763f368b71c08fe3d389155a15bda304c2f65398c86cb174"
    sha256 cellar: :any_skip_relocation, monterey:       "468e08511605c7f0219a01554fbb01f87132dc9bd9a01b9741d997732de271b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "90ad07808dbb9a6f311ba4a4fb7f49c2ad2566dfd85f28fde6519cb1e3707be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7ed309ba3ee11b0555a02e1d55c6ac35b0c213dab4e273358b3f8fd01c179f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end