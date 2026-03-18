class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://ghfast.top/https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7960b1113165f04944566826ac393cc943a4bcc500aa73103d9d00c2d3100f3d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69f83273cfc31aa3e8c6db27e38c8151fc68a2ee40fa161ae2ed401246845726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b132ce1ea31ce26dbc730868e0280c8fc7f0de0de4ac5dd14070db3ea341cbdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9845db03d60057f8db82732c9f2bf830bcc086f41c13427255833890b27155d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c31841f0a2e97932bae4ed9e7b55efbe104ab1e0d07546589277c73c83886f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b4b652048a752275b781bc0cc79c9e7481937462396da72a82d3263a36af01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df533f7c48265c688a88b6c6abe4c30513b7b48e768302f6a64654be2dfa7f47"
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