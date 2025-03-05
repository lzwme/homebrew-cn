class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.7.tar.gz"
  sha256 "9dd58cd426a482dec174e894303a483b970aeb9a04a948cc5d853db49895f400"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fdd24fe4d3cb4f3cf90d16bd2c645272a282fd255e183be05dd5220e8bc6934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3cf9d28d74279ebaf9a54dcef883e21a29cda6518ef2c6c8fa80c2909efab17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f5ea95955865d2ac239a52302c66e5cfa2b669858684bfc05d026a73655242e"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f9a9856df7fdf0b4de6aaf86db362ef64647a0a5eca293bc35ac542933668e"
    sha256 cellar: :any_skip_relocation, ventura:       "eb5dd493dc9d32ca85c5132f045c0455910ee62b179051f79fb54eee239441a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1015de757036bb27a3cb4dd46a64ff789ebeb9c160b22360e50a4bf4712bd6e3"
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