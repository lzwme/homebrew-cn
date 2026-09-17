class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.40.0",
      revision: "d58446e631b02cacc5355e373defc6092a684554"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a79fe8f081c77718538a0f6d9a13cf8917359af4088a20d6f3e30748960081c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe1941ff3ff9b3ac76a74b9216d5d74ec4babe3348bd3296f2fced78614bd95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8b6d20d8d19596b3d06f563c79df00cfda92e3647d17ac30a9cea5355c5a387"
    sha256                               arm64_linux:       "5465af6ad97b923d6cff76306b5eacfe9811267406bd74d48b4e16f097d20c57"
    sha256                               x86_64_linux:      "38f000db2857431ab90a425aedf574f6e0d12a65616d7c6cab966a375f5bdb73"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  resource "homebrew-testfile" do
    url "https://ghfast.top/https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
    sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
  end

  deny_network_access!

  def fetch
    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--download-only"
  end

  def install
    system "opam", "install", ".", "--deps-only"
    system "opam", "exec", "--", "dune", "subst"
    system "opam", "exec", "--", "dune", "build", "@install"

    bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
  end

  test do
    testpath.install resource("homebrew-testfile")

    system bin/"stanc", "algebra_solver_good.stan"
    assert_path_exists testpath/"algebra_solver_good.hpp"

    assert_match version.to_s, shell_output("#{bin}/stanc --version")
  end
end