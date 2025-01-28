class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.11.tar.gz"
  sha256 "9e7cdd6e796fd9f3ac98e1a6d783402b017d290da9cda5effe873eb687db3571"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0682b1e114519461f3636221222c9c554a950d232502939cfd77b39f5f5cf09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc4244d3e49037eae63438702ec597dfe98b7ba27c623542428776e6f60caf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dba112ff98f2b4df386e3d498d4e797044b907103d042d612a67942483fa69d"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ffd8145bd29873fad9b375b2aa8e3f2956a8cb3781cf2bdadeddf03804e6ab"
    sha256 cellar: :any_skip_relocation, ventura:       "c1679e20d740805e24c19fdbdd9b0d64154fc8034b1af7464c893f6f87a0f3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdbf9c821f580acaf90350630411848feef3337764960b1643ec50da51b05e58"
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