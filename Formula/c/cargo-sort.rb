class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://ghfast.top/https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "95bc564567b753fb61ee241ee75a2bbd5f44b72af513d394a9ea7ecaa5bf82fd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2301cdea0d63cbcc8ca9d5927a4111d7124eb5d6e80e3697ca3733222e4d070f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99444c00d59aafca88e76b2013820f9563e603e4865f8e070415a6e6960d3200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba667c5a5d9a7cfd42be5edd537b02844cbf2076a38556ebc6a9ccb3c6a193c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e7e9da0ba771bb6ef2194f2c1554e1c4f9f30a21ea8e7b387ab62c927aee91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a582c8f5132b564f104c6a0367a8a42f8fc9a522e1694f8d64201f529078b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd48e893976664bdd1a934c864f64ff9d6f26e56d92258c272d117e10ed145c"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-sort --version")

    mkdir "brewtest" do
      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"

        [dependencies]
        c = "0.7.0"
        a = "0.5.0"
        b = "0.6.0"
      TOML

      output = shell_output("#{bin}/cargo-sort --check 2>&1", 1)
      assert_match "Dependencies for brewtest are not sorted", output
    end
  end
end