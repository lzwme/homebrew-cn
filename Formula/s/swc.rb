class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.10.12.tar.gz"
  sha256 "f232ca1210fbdb06f045c9aee265499748eb7a110f15ae9e0442702488d21bd2"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507a38480f8a06b42e3f20f8117f0067e9b7f3d5d3245af81b9df07faf7c054c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ba4cf8a624ae91f6ecc2b52ad5457013116c5759fba6c820e1bfca395ea516"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c2d5168a416b3dfdfc6ef2bcac6ada05da5ae1c52a4ed415b413bde7c7a13ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a15c6cd8f3d2220e18917e54d61578e00a0a3fb26f70148f1d1aed7281b9c1"
    sha256 cellar: :any_skip_relocation, ventura:       "f5f7a95784b5e21544d5d118b80bdc8eca8c0bf6c90b69785ca40c994f906685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4fe8c228a2a14a599fae86ca776fd207e53022a412021792fd00c7d79ff095"
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