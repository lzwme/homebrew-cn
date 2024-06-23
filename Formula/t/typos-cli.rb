class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.22.9.tar.gz"
  sha256 "8ea801ebf5465e562c31a1f47e591ecc6500ae63d58dc70aac59e0446b0fa123"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0907989c4219be03c9ac66ba5405b59535aa630e408f20afeaf130a7d6f7aeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25cd23676c3ba399a4a3ea2a548b0b97a2d971ab51b19a998f3ad4b8b79eefb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18726b38c17843815aead12697348ea5a6d1fbaedd4e5c76b080efc16cc39be3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b113ffcb85a8bace8ac928ba860c08ac7f3e8411c16225b5ba51bd4a8a39b3c"
    sha256 cellar: :any_skip_relocation, ventura:        "809e3662eacda7c5891e494809fc07794b2593588fb2d389327052fdf5dbe4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "2249c31555a9a00156da462c4dc9faddb8957545ddd745a1780f1db0e0e0709c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518b1968e65f9494fd79c30c68200b9f7cff38c825732751777e6690fd7111c1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end