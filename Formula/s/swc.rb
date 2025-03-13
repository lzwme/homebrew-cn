class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.9.tar.gz"
  sha256 "f696c9e3b2732f0a923e0c2eed287a1eaefcedbab02ec116d5ff246083537942"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54152adbf2d007cc75c05aead879738ce50300a53a3f0a993613bd43ea4d11c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4572172716a48e05234e90eeb64316760458a6596dbf663d0a125d94ffa9fb19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "685c346282d0d6d64ad0ce332cdff51f28f591e81807901d748f1f4c52346d05"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c1d9fd71be265e5903966925cddd404a834e0c8242a08762f87ebdac0843cc"
    sha256 cellar: :any_skip_relocation, ventura:       "0410b304364cbf7c1cbae321bd8197c916835a08b60a2ed7e0dbb7008e576d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372eb772cfd10f106fef15d15b9c268e1ebc56b782203d584696ac54e5298f9c"
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