class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.1.tar.gz"
  sha256 "d1ddde73258d7b2774c5c2bccdedffc45954b98b2d9a76b59690fddee736b3f3"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3f02db03ac0c1a4fca78a1ee6c5ba5cd7509b8f603e738a8d993f646ec4cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c79660ba3092afcbb88e0859d9e7de0c88653b0310398d8095519f14f979465e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bb5c37ed9c07f83b44e732527792c9af625d02666d49f121e308310aa4c405b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ec4b9def538bb55da2e9396cf93ecb3238f266eba8d12a10bff371d8604106"
    sha256 cellar: :any_skip_relocation, ventura:       "9d7778fde6e668180471b9b2d2364891b19a12edf4e097ff2a47b874b43d57ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b82113dfa68feba58c4fe6d30d2db3e0b6159c4816448185f50981571347f30a"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end