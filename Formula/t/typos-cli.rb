class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.31.2.tar.gz"
  sha256 "41879be7e1fa39b4388df2752c20e0ffcd30f39c86ed0293ec07d48d3352de6d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406379b63e10bfea96534f3156e90e3aa3a75555151dae529b3f257faf6346ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8595ff1b93a39b5c7eefbadf306fb2840830e18829117a9edc68687504d54f5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e468b7e658ddb7a0b84b5b1fb56294d372fa3791290c6206d247c5c4cf33f713"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd19655098a0abcfbec7d690f3a6d10a6bf41b3d71cb144b2e0ab3d89b6acf85"
    sha256 cellar: :any_skip_relocation, ventura:       "280b2600d7e63a7e4ade63f74edad862a44d3f1b46b749db28ea2f138ac6103a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b9fa7167998c6ffb0ea84d0477e56c0ee1c14211ce2de900701157d4c442a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c992c89a4dc86bd0174d38379dbff6688d864186e95822ae14a6b46088a31b02"
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