class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9f99c60b41459a65160c95f69f35ae740bc1dfec47d5e2227b61a2eb44b0bf9b"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8da15f676b4c905fe824bb5142065d9fcb3e411b7e56bf01ea7b82f2d1e8e10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bcf5b9b93fc95bde42b2e73b11d78c6e23111e0b8e5badc6fe1689b7fac750f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "192ba975af7b1da7de68a6efdf6878267a5d782065c8f65e4b0656e3e0a65058"
    sha256 cellar: :any_skip_relocation, sonoma:        "e32cdfe2f749abf432dba13c371ae3845400749b0a72d30f282c44603d1091ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbf8e09eb8cf035c1b5fdc744d5cb977325a767e6b9bb2d1f4e4e99f2e2135d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "270c3cb03c2bafef248a6d21cce24db9adabc0e9aa1f9583aad7f5734d3e5c5c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end