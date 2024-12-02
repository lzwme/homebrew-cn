class CargoChef < Formula
  desc "Cargo subcommand to speed up Rust Docker builds using Docker layer caching"
  homepage "https:github.comLukeMathWalkercargo-chef"
  url "https:github.comLukeMathWalkercargo-chefarchiverefstagsv0.1.68.tar.gz"
  sha256 "2cb41c1f9060965c33db781fa85b5946d2cbc64125d66fd38adddb6d71b43108"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8102a4247562a79cf1ad4204d8e95cd1301693b68c64d759e3664c5c968a3bac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc04f1f8319de9ac4dc1198e4fc627c6dce7b02c6b401362ddbbd28c7bb793a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8099c47bbb7ec61c982e895617b3b69bac8dc673354edbd657354416f710b847"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3fcc1ca81dbd31fa7bb04789a73d5cbc2420a23a9a82abe1fd7f14eef023400"
    sha256 cellar: :any_skip_relocation, ventura:       "0a8d95dcdcd0d83e587a267ba6cb2ce09adba00cfc6ee36e881b73f26c9751ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc645198c9f0f670d0360cd514374bf100dea7301015759caf5f018ddbda700"
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

    (testpath"Cargo.toml").write <<~EOS
      [package]
      name = "test_project"
      version = "0.1.0"
      edition = "2021"
    EOS

    (testpath"srcmain.rs").write <<~EOS
      fn main() {
        println!("Hello BrewTestBot!");
      }
    EOS

    recipe_file = testpath"recipe.json"
    system bin"cargo-chef", "chef", "prepare", "--recipe-path", recipe_file
    assert_equal "Cargo.toml", JSON.parse(recipe_file.read)["skeleton"]["manifests"].first["relative_path"]

    assert_match "cargo-chef #{version}", shell_output("#{bin}cargo-chef --version")
  end
end