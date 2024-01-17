class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.18.5.tar.gz"
  sha256 "454218c79471e0e3a88f839f882577e606864c8dff4339be9b4299ccc2026350"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fb1bec507c1d1d4b028dd98e941b7301945015eeb95c452fe2f8cd5c568a049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba07a7fe3f6c3516ab3942131b695649a15d86f9c0b0a58e3857140802fbce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63da3e195697df0ad2f67c6e0be8d175120559384d2470c10cdb4430a62eee97"
    sha256 cellar: :any_skip_relocation, sonoma:         "904bb576b5d6b10e7bdebd033f271fda8c7e81fa4e0d5c5d842e1c68d999cb7e"
    sha256 cellar: :any_skip_relocation, ventura:        "49a2f94dc259f03dd0e3be339725f156632ed92433366d8181a220226ff443b1"
    sha256 cellar: :any_skip_relocation, monterey:       "155e5593c311c5757d5f9a95350b77f89b59c593d1412932d8ecb97ef75d35d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef59988cdce67603c75ccba319f9a840ba5281d01cecc948fedfd5f37257454a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}trunk config show")
  end
end