class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://ghproxy.com/https://github.com/peco/peco/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "8e32c8af533e03795f27feb4ee134960611d2fc0266528b1c512a6f1f065b164"
  license "MIT"
  head "https://github.com/peco/peco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6ee18836e9fb37550e7245924f49a2c4fd6031d0c03398838e93f5ca0ea80bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ee18836e9fb37550e7245924f49a2c4fd6031d0c03398838e93f5ca0ea80bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6ee18836e9fb37550e7245924f49a2c4fd6031d0c03398838e93f5ca0ea80bb"
    sha256 cellar: :any_skip_relocation, ventura:        "7a91ef4b46bebf8e13308598da973d70b373e30f0d0193e771b1914198120cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "7a91ef4b46bebf8e13308598da973d70b373e30f0d0193e771b1914198120cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a91ef4b46bebf8e13308598da973d70b373e30f0d0193e771b1914198120cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79dea96e98bb408b0b87bd9b2ea4371c035e23b49c1de71ce7c7387f4ffec51"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    system "go", "build", *std_go_args, "cmd/peco/peco.go"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end