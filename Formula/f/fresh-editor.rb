class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://ghfast.top/https://github.com/sinelaw/fresh/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "b18f18b1eb8feace2df827b23ee9943f723c00fe141ace3d2b41e20b63fc0e25"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879a9dec09b4afe6f036c0fbda49702152030eb9ee233af23b2fd0e4083c303a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e0e799be423fe0d268dfa56f09aaf1a824a7b4ee071ad727d304099db2196b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33f7c63e6a5736065c212e5c13f2950a38f863e65a75d0d4799ffd914e507836"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e1e41c69bbea7c543254f9f94c3cab684c139291846acbaf95d3148e34503ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f189ac4599b5c5e146c15d14c310a0f120e9f4d649edf59d1e4132c6e5f2b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e38bc0b0f4945bf7b705a6ac735ffd23cf507e8166d340162c0640232b9a5a"
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