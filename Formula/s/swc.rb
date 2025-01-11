class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.7.tar.gz"
  sha256 "562fbd305ce4292f7c5b9265ff44ff3314653af582ca5d8c819285657c7df23e"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43e5abddf1b15321d6824e4aa424d4933e82c0031ddbe9cc4ab617da3a17140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14237d61e76a9b59763414502dd7d83b794ae85986c45d29be525b865d28f85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3866135a448f3ea1e1ae54f115f8f4fb6444977df9786740f7aa3e9b9b87c38f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4246b42f093a10d108dbb0379ce0b6f6e2213a05ccd442a25707630e36917ea"
    sha256 cellar: :any_skip_relocation, ventura:       "d15be09740220545a17199276478b48d04387306100c307ebf8819b976257eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af2564c7a3569eb120115b81d00df02064b1b8f9c2824d632ae8db40197c6d70"
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