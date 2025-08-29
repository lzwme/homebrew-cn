class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.35.6.tar.gz"
  sha256 "13c8c2c2d4b4dae3f900e92b1cb56740e300877c1cf32f9e5654b1c6395fd561"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "096f3c329c206c5aec1cfb54ee763afc3ae01b34bad3be7771ab5f5dfb8564fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48715e11bded1af9e2bfbd0465b430ab0e9ee35740a3386be466d2d2b980d811"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21069278915bb4768ffc4ca6628bc0ec4030a8e6195ce62ea80dc66728413ef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c9bc90da94f7951caf0f9ed9c624b755edd2c7c1d8e0d7b55053e13d98621b3"
    sha256 cellar: :any_skip_relocation, ventura:       "943948b46398938268271301f74b0a3a88371504128a5a4ea562246bf6d26816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c0ecfc9de86db7d111c68ac67a13bff7b7745a45b4b32d799c23730be8a88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d9082542f767063e5ccb5cfd7d6a236521dc840f25c68bf04bf75b91da512cf"
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