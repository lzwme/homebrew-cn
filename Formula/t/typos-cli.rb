class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "34d738a30f5c46b14e3d963475ca1b16933b4cd61a352a17c63aae82f3160ed1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f578d2d0034679ddb2ddd69bf88d5cd14bd7354aabe017a0ce99dfaa785c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "affd623e9b7d6a5dcaa0ae55d187dd236a925421a245010805d14399704d7d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cd769415dfe07a5afd3198496ebcf3f9e62726a9ff05c7b3bd142183b0afec7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebde6b3d632cedeee5e42c7bd2b0abb4eae38d7f79c4b32980f5bd0e4e1c5fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0861cae3dd65055b3c8c08daa901697083364179799b790277f72d8a36506e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b501de066e98a1d44058f03abaf0e380efad464fcea040cf5ac21b3e3ef813"
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