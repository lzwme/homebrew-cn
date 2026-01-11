class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "ed80e990de97852381023a4d05b87c86c84bbd5f0bd4a1d736d51aa234655f9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7acea778a89ccdbee34e8379e7a9e281fa81d899a32a202032864bd3d3831ce4"
    sha256 cellar: :any,                 arm64_sequoia: "aeaa7ac88a4cdc509d5094327a2fa71929ccd94bc60748e89837324bc3e6b6a3"
    sha256 cellar: :any,                 arm64_sonoma:  "a792bfc638b5e099f864d697620d19b61d31c5b8269c4bf6ddb62ee59fa6a7a8"
    sha256 cellar: :any,                 sonoma:        "aa03096431281d676c4e2b11022f6146a4d02489916246ff1c08ed00e5283b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a564f18e779c05367fa44a76ecc031e1f4a7f9b0133285725049ebf291e4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbfe3566fe8865051993e9fb6351e23c0b1c45b7ad69bbed84eb873be356c855"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end