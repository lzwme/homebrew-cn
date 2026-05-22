class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://ghfast.top/https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.2.tar.gz"
  sha256 "03c7b97f34763582f738ec7f70ed976fbe73ef47c13868ee3dd978d5473031fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0868ff3f9e8c54e12fc2ed87a9725208b0bfa7a34d532da7d6cbc98b3853b243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ccadf179710c1377015d3c8bc6414a4368ecdf47ea3cd305526bdd58e928ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527a1925ac2a97f7f9cffb094b9acc3e0d987cdbeadade9c00bd3b8f5c0efacf"
    sha256 cellar: :any_skip_relocation, sonoma:        "81ecd2f3d7095c8c49670ec860f124493667a10f00cf30c12c4326de2a105ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ec44b8448d22d1156cb16f26f94263d7d146725ef1ba7ae35824f9656a5930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2351cc0a0973fd2a580da6e7fcc7c7224198da6b768887ed2fe65f41909fc37d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No valid Claude data directories found", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end