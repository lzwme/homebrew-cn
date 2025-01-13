class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https:github.comLukeMathWalkercargo-chef"
  url "https:github.comLukeMathWalkercargo-chefarchiverefstagsv0.1.69.tar.gz"
  sha256 "72985c4f4912d60b72711da519c8876f7414416fbb389cbb03ea7d644f20db32"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e1c3d061b30ecb971ccd9bc9dd12d3d73e484abec716b8c71cead8d654b5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5a3d8021f93143cbb436861e810ae80ee72791e8f4ea2c60ce4ef5bf86b15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3d32906fe2f0fc54dfeb59d059275bd9630f203592ab1b074544bebeaf62207"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc5eda7da0ea55744ed2d508ecd97976bfb9fb01f6b3b0f0285439a78ef02bfb"
    sha256 cellar: :any_skip_relocation, ventura:       "72538bf667714e6ccdaf8e20ce4c4139003eb05571cb9281dd113ec3df4cae80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4a2791839c532641ab226e6b42e30c613b74995c0a78ea6fc0042c6d7cc7c2"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    (testpath"Cargo.toml").write <<~TOML
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath"srcmain.rs").write <<~RUST
      fn main() {
        println!("Hello BrewTestBot!");
      }
    RUST

    recipe_file = testpath"recipe.json"
    system bin"cargo-chef", "chef", "prepare", "--recipe-path", recipe_file
    assert_equal "Cargo.toml", JSON.parse(recipe_file.read)["skeleton"]["manifests"].first["relative_path"]

    assert_match "cargo-chef #{version}", shell_output("#{bin}cargo-chef --version")
  end
end