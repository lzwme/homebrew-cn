class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "6f7a1ee18d75a6b745f98ca95d4264faebfffbb2ac483cb026d1da30ba237616"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff08cdacbdf9a6d1cb97122e83896324c4ee7e0c557af1c0e89d69d19c8b9d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f9c471d2ae7ceda6a3208c8b5dd4afadbf806fc5a3f0ef88bf33f8eeebb7da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69002dc39b45c05378ead8678577cbac952470b1addcaba22f3a9d3602da2299"
    sha256 cellar: :any_skip_relocation, ventura:        "a33d903fde3d7659297aed22dc109e68638623086a69dc094ec4ac42b71b630b"
    sha256 cellar: :any_skip_relocation, monterey:       "75488d700fa58c763994977f4e56fc4667264f6a1123fdd7aa494c92015e1722"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b94710a6cd4d8e189c12d7a35456a7198be1639b6b1eab0e0dbf8f75c1522bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f049886ce4c08aa528356da70839e960036420b7e5c36ed96aa5c954406c33e"
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