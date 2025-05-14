class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https:killercup.github.iocargo-edit"
  url "https:github.comkillercupcargo-editarchiverefstagsv0.13.4.tar.gz"
  sha256 "afcf319c43bc1ca025c7607e7a2ddd429ff8fd65026acc4e1864c7853ccefb5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc75aa0aea555ef185487163cadf6be4866fd70070f082196d3b2ea3a9a3e2f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0c502eb246b65d9b03044c10d81322ab2620c3a079aaee41f140f60eb58116"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b663208ea57a084f3639e4c86ed88eeadc025d9f36567abbc95c982ff839be24"
    sha256 cellar: :any_skip_relocation, sonoma:        "c65290bb99961818bd4d171286ffb3c2139662fc1ab41a0e3537eb55a24908bf"
    sha256 cellar: :any_skip_relocation, ventura:       "bf751186034030f204157b263a7635d003e9cec188c46680c4a2f52f2b04df29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757345eb13f3bbcb8308def799492ffbff4dc41dd49739c35e27c7524a3e4313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef9f1924afcba2ba4591ee5954a3994abfa51e044f1f28695754447e96a3eab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath"demo-crate"
    mkdir crate do
      (crate"srcmain.rs").write " Dummy file"
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate"Cargo.toml").read)
    end
  end
end