class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https:foresterre.github.iocargo-msrv"
  url "https:github.comforesterrecargo-msrvarchiverefstagsv0.18.3.tar.gz"
  sha256 "5ebe6dd493cd9641d31cf736458ea0ef61a74d162ca0364b56c91239efc88ee6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comforesterrecargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1ba56ad77fbd7b986c1d4645eabfcbf5e945b62a2b6e3913433d433c56ec12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccfbb358d7fa2a26c3c0cf8d2c5e4e33cdc1c20e3142b249e02ff637bd96f9e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daf377e846a33a704032ffa2884671eeaf14b4c424f8647278643a8cfb578878"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4c2df9052995c392d2593f76dec47f4e59b391f27b32c834f14416dd178d50f"
    sha256 cellar: :any_skip_relocation, ventura:       "44d546a93282b93cdc519eb82c43e6a7ff0a317959ce08558ce0486605338fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec7eb2b2adde497a73003925addec0f94f4120e709b8e05e79cb921f4506bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3071bf253f249aa4e37d5a52a5b52b0d03427d7c99f7adeaa69c4f2f655e4111"
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