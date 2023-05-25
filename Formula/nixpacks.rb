class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "d0f4c98b09dc84a89861c08adb51b0b2d64b59537ecc103af8fb847c147aed42"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e4583c48f557729235dd240c3b2b36ad7182dce21e3107a7b2be6e26566bd29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc7f2ed946678a45fe01a5cabba32d34f22258b283356978d4335b8fba65921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a8ebc9552adea893457d728191d564f1c42a8475222550b21c452338250c769"
    sha256 cellar: :any_skip_relocation, ventura:        "42d13946325b753c4c6be2109d21231c0e9a2cc364f18632b47213612939b35a"
    sha256 cellar: :any_skip_relocation, monterey:       "23aed79583488f0c29e017c8f60d1b1e3e04c3b94a88a0e7224a25253262508f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9105a7a9626f1f297ed92b21c145d6e8200bcd2f6c97ef7399f2ec76dfbff812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78cbcf108f8a7805ecdcc4326900d5d3cfa62d50b3168919ded6b56fdb15913e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end