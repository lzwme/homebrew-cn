class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.22.1.tar.gz"
  sha256 "7b0dac2a8f96f6131d78e9c8b04e2d9cf88098ade32eb250afbbf80fd429eb4b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31b40488ebed9ecb2e643c6e8d96852341dca5c51dd700332782ef0269812c58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a932a45aae4c3426692e6023aa92fcd54275747140a6f4fb71c000d69a5ec1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5119e7c2a7a8ee111ea41b76692029fbb831ff942371d9a6aee2ab9ca9a23dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8388f3b27426533d65350bad53536e3cfd07d5215ec61930838bc342feb9b90c"
    sha256 cellar: :any_skip_relocation, ventura:        "71d8d49e0ce754c7b955b2e41b61d229cee71e2091cdc83a94f1174d5567537d"
    sha256 cellar: :any_skip_relocation, monterey:       "036b768c6ebcf8ac7d8ae9f0645105839c88fe99ed5453913f9268815f6c7d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c83d2e90beded1cf2694d6999ff6439757ba5fd17d6dfd5df7349b68df5530e"
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