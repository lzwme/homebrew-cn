class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "947d761577cc4adfccf685c091ed1f32f92a2982c7dd61f48d6370cd46b8e2bb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2581dac76f1f863da9108fce39c6323a596164c5f41866ea59a72491e7fa6c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0549517d1c8a9ea3ae0b28070df40122a13359b8f3f8a5b3d5f31d5a7364feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba69cd87a8a297084f874aa69d90a3bd19eebe14592dda2ab3823fe16740b8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91044f5258dd33ae528afce114ed1abc8157187786261238c75ab9064a3ebd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ea4b99d135e93266180eff3ce29d516859d65a319d253d7f196a6e9b670596d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c7185366f055401633decee5f8848a49de9388c8634070905bfe80d184b2d9a"
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