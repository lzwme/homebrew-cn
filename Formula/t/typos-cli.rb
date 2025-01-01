class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.29.0.tar.gz"
  sha256 "6427c063b5ee5003cb7878d3c655df204574d6a3f8ea8fd618cdab67177c27d9"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4d6e366621fff058bf807c53c0742f25ce0f4d4c36d770a135dbc78b9679f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c6eb5ea45cc32cdce9d9d24d20724bc1484b08c6f1d01408af4642c693ce75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a25fd4c8e50ebbdc8c63d2cc383f10d94097bc91e08668f3ac5b21a780f6bbfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3afd94e0e23708aa03bb671ac6bb59f8d17a4d8628db0b6954c566ce6aa2dc"
    sha256 cellar: :any_skip_relocation, ventura:       "57f30e97567329d8c7c01b13a97632ccb18d4a0c5ff26af9acd7fab9e5e9ae07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7a8c819e8596f8b9035591e9aba59fbc2bb62c40379a4f1b4f3e1b4ba59492"
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