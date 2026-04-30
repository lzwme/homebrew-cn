class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f8a3946662accf1989eabc4204333ff47e80214db3c2bf95fad45feae9c197f8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "127484a855d57742f80ad9dc4c97820b310d05762470984d2e0b79a251cc8535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dde7785c3c99499ae079816b3f9fe67958db745118819f33b74383b047d98ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9553332acbec7242c9918f94c1463a7c31a4385761547f45b8f0aa46ff7b908"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52cf67982cdf4611a9edda4dd9c6df105a8ce0a90eded128e310e80e63a533a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "067eae2ef7a47b80eb66e5ae52868e47d7f88b4ef1c6f963187377d9fa696729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e71f6b164796435b18bc040a7a9de27558cf70a07b29b269ff2c6a871dfde1"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end