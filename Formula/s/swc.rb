class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.18.tar.gz"
  sha256 "84131b894e375cd1607b79d8238f703201e7a3235343e48f412fc8479825aab8"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b28a85d1669c6eac1904dd29634398033b1aa0fc74852e4a52e370b7394e3f61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d630af520d05eb5e801758f2a7ccf97a8168862897b69f815f3741f37a7fde73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97dca6de9958933d806f10df1582c55c95bbff80fba85c6f7f670b01e02d0ad7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5f4eb1c7917b251fb1e9af293d86a062a575a059d35e906824e421444b031a"
    sha256 cellar: :any_skip_relocation, ventura:       "c7c288a30f7b13e2c78b0a0baec47e7a4e1ece583f0e2e3a0c5f62aee6b8fdad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d905c30367beaf3b08364c959c669c5fcd01ebba93310a534e04a406aba31e"
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