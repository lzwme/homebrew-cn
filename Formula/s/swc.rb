class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.12.3.tar.gz"
  sha256 "32004452c5130f52121050a0246854bc913ce874a0115c026d314c77702e38c7"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf8777b768801f63ee9df9cc4a29a2f2472e9292b1f7cdbae289c917a473c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c577972d74a2f89dc9f5f24863d7f5de266dde955ec1383dcd7daac265f358"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71f29758b939d625a28ec960b24c553e4584b04d03247cf8bd7677f987c14ef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6503f6aad90cdb8841e50dc8a316d122281b4dc308cf7d7c2ca910f911325ae"
    sha256 cellar: :any_skip_relocation, ventura:       "16534a8004abf2cf4dbf03e4126c6825dd62295a6c3cf7cab90c15f0dd9183c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3dd7b6ae2a8de52cdcc38da83428721a3db7af433c681848807900b5b38d4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3aa8b5e1a8784bfa631d299468fca40223ff388d98675d6159c11807187541"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargoconfig.toml"

    system "cargo", "install", *std_cargo_args(path: "cratesswc_cli_impl")
  end

  test do
    (testpath"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath"test.out.js"

    output = shell_output("#{bin}swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end