class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://ghfast.top/https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.8.3.tar.gz"
  sha256 "1108776e0423408f3d0b76862bd01bb92711a5f74f656f4bec8ecfaf1d67e7d5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9640132a3b12925a132ef1c4d80ef7775b2ddde3ef3f27db1378c17303cf60b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8e485f63d2de85d6818da95c5b9c32e71265878f294b13b4b06307a338df52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dc6a18414d09bc3737639558db010a2109ddf57edad47b0d5a71af12c7b17b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e73f69379dc4b452f44435527435a54455c7c7ec9479c700f2125d1df6a21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d97af7be6fe0c5d5a73036085849ab274ff781c700285378315e6fa9d802998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197a58430f82d641a9e0244ad5acfddfea4a74f81845a1cbaff749895814c311"
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

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system bin/"cargo-about", "init"
      assert_path_exists crate/"about.hbs"

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate/"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end