class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.43.4.tar.gz"
  sha256 "91c66bed9778a2f1ecd71c75c9e1156e3d4862e7b830230d33d8eea1059f932e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6bd6a468dbd5412882219a6cb2931fdbad3e0469cacca4c45e13ba1c97b224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e674a6e997086f1d21e58ffcc9bdc50df88c8839b4b09297c0b01ad24504d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019e1e39801e6a063b44d5891724ddf98aa5f9951a5b71af8a3352db1a4da491"
    sha256 cellar: :any_skip_relocation, sonoma:        "990ae9ae50cfda5afc18a9628f7c3b9cc4be8e73da1d199d8759fe113c853616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b292d4ca307b9b300a83a33129aeacfaafe17e739f61baf17534f793d64cd42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "349de4379257fcd88709fbffd69506e49501a6a483b2c3a52aa35417e2fc6e46"
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