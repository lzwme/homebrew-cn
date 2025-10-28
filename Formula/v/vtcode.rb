class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.35.19.crate"
  sha256 "cc27d2b9088ebbbd9afa839fa4ec4ef429ebe0beb6439df7a38babeb4b363ec1"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53ed525f2670d1fbf822cd759c777b72a592ec3fa8f04875700ab0da0fcc688c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a21dcbc0d76a6c69c14c8f66dc8afc35b906ce6ca535e6fca60adccb763699a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a922be1f653665069ed36cfc880e9d188cdbf2b4f6935064fa7699807247b36f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc5d32070c52fb5cdbb46592a8fbf588a8e4dae7809f9e826d83e473cd7e362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f0e9ffe39794e763cee3b15c0b70979dd40c3915c81b6e3692c2e3fd6b3916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ed1769779c2d1cf442b97d1b5fe9a380d560340388b88d417e90e6ec68cf1b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end