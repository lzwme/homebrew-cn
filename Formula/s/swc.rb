class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.8.tar.gz"
  sha256 "d93b0ae7f93189921cff9c7aa8466e4bd55e5083baf999a65471b06fdd9f8b0b"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbe69269f8b20fc748cef9653698cea9a0c1d212974e912cff283cd9f4b6214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c419cad6bd9eeaef5dee2bfd9507dcb1816976ea41771d27b2140ced5290125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "234218dbe859f2a98022abc284d07f40e60f2150111394f0896f48d72ae1ba5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c86451866be37cf7f297beb5601e14c16b61f3d212f981157ed4083bf429488c"
    sha256 cellar: :any_skip_relocation, ventura:       "a77dbafaa5bd7c6c8b9edb240849a9bfa676c27793b274eaf8d3f1c904fd1aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452a651435dc9315a16102f4aac8d62ffbe782fba6b9d40ed6a87f8d26293a93"
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