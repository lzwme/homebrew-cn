class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https:foresterre.github.iocargo-msrv"
  url "https:github.comforesterrecargo-msrvarchiverefstagsv0.18.1.tar.gz"
  sha256 "81ae871c3aba6d044b7f3fcee7d7a102f5f673f45883afb23e57663e98ef6bb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comforesterrecargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0df347ec1d758f93f77fd9ca1c92006dc0c6be8472dddc3793acc9b97906b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203dcc24f69c8c1b8ad44aa052942af6ba1db514edf1aeb7db9df25c6aaa4b31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "297f0b7e6c31db06098f1bdf013a96a0af000cc7d0143faca349f5141a075da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "be27e3b2fa6f82735ac92237b3cb2af8aafcbc7b1bdf5a994e1f2fe0c3cfd7f2"
    sha256 cellar: :any_skip_relocation, ventura:       "a8fa3e5a881a11dcf3aaaf5815ad5c37eb584f67ea9089b881fb98d49ee797b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71b8cbec3a53b019947df3d65ae4760cb213dcbf7880ef7c39e56ccae869f2e"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}cargo-msrv --version")

    # Now proceed with creating your crate and calling cargo-msrv
    (testpath"demo-cratesrc").mkpath
    (testpath"demo-cratesrcmain.rs").write "fn main() {}"
    (testpath"demo-crateCargo.toml").write <<~EOS
      [package]
      name = "demo-crate"
      version = "0.1.0"
      edition = "2021"
      rust-version = "1.78"
    EOS

    cd "demo-crate" do
      output = shell_output("#{bin}cargo-msrv msrv show --output-format human --log-target stdout 2>&1")
      assert_match "name: \"demo-crate\"", output
    end
  end
end