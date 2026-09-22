class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.85.0.tar.gz"
  sha256 "cd5fe4bb755e4ef23b4be0ebf11ae4f6c84b46add4104ea06b04c32f2e4bf3b2"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9d060806c356f0377e29ef55e19fc07f1d337e6889531fb77dddd24d8b08fd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5bcb325b33ab83689d03041dfac9e2442b1f1510963e0690ce9dc485ce52519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95a86d3144240e678bb60fef2fb820899db23d56cbd5add80352c71b967dc747"
    sha256 cellar: :any,                 arm64_linux:       "c683245b3bb1c75644f43dc6b4aa89b45b8b77bcb5ddc66f30ee33644e356a1d"
    sha256 cellar: :any,                 x86_64_linux:      "66d6ef02ed3f75beca390d7bd4d8d713ead878c2fdd6803ac987b0fe1e916449"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end