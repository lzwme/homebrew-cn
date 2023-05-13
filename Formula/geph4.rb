class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://ghproxy.com/https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.2.tar.gz"
  sha256 "c4e92e71c75d7ac4c556da9344ad73283f6c3de890d88af15d4a8c2f248b8708"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c43ec88426f5f2b18c5708a415ca1c330d74b39e504a549e2bc432e42009033f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1ce10a3241a0d7f40fa58157d55e15446401e4d2c1204191976af681403e607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "750b3b2c0f87ab4367143e32d2a8d125d068b40f791f75d617b46857701bf6ed"
    sha256 cellar: :any_skip_relocation, ventura:        "8a1d11a858d37ad107db8cfbc5bf61bdb360ca0d8bf355d45905e4f76e948285"
    sha256 cellar: :any_skip_relocation, monterey:       "10719529538001a1a14b21f190570e48b9e8c9f86860757f186ce86c28a77d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7769b641f07ee0e0e2b7124e7e9d7c3b410aad48e44c4c8be5f955372d535a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0e345e2f31d4a708251d50c2a37a81e04287ff2b3b87529faa5e509590473b"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end