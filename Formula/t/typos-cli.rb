class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "d2082786d31e600746896b523f8b2c18c89cff0797bd34c818636e3808ac4d4c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4447209c37a17335390a37864ace1cdbc8fa68dcede0b61f696ac08568b5468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78061754cc965ef76e70650241995248c88b373c983e8ed905917059c3a61848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e783f037a73884eac621332c1ced8359a06545dd44cb441275736b45672688"
    sha256 cellar: :any_skip_relocation, sonoma:        "d13e01001ac7338d65b010759c83747507e97c9abe51ced011af241901489cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef0f8064734426502a44d3589157d420513917c70320bd031021d1a68c8e24f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b3d5d6cf9f8e888431e761af9b69408f56a6d331eccaa5e4f657828a1f032a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end