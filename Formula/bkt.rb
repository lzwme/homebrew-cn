class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://ghproxy.com/https://github.com/dimo414/bkt/archive/refs/tags/0.6.0.tar.gz"
  sha256 "59c8fe8b29101a47d928896468dce2f8fb3cee7598201d46011804a7bee7f6e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ab24916de5dc89fdbb94538877c537823ce6e38bbd69d0d8aec8d1cd3a6f52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63bf63f273ab6837b8f85da9b522bdd549d59f0d5bbc36b6e0c4b06a5815159b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d7b9f855cd66b21f91182abe474f6176410d1defd3aeec7a1bc7b5b95ea7e8a"
    sha256 cellar: :any_skip_relocation, ventura:        "260a2194f8643e102b6391807271d7efb0c18f14dffdd656a3e6bd7951585575"
    sha256 cellar: :any_skip_relocation, monterey:       "2c67f34df01c4e38cf6fe3a417c7c2262ccc23adfc2942e1681a3ae82edee61a"
    sha256 cellar: :any_skip_relocation, big_sur:        "485836132fefe15f74867e6de4755c44c1339f1ee09c8a7fcb73f833367e556e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "571d23d04ef421ecc46863746252a823357eb9f9e62f47c858cc73c3379c4029"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end