class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://ghfast.top/https://github.com/DevinR528/cargo-sort/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "b36cbb05b8142794e1bb791eed543d282eff438d1422d3388da4fcaa32cd7585"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/devinr528/cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92b609950f97e55e01fadfc2deb660d04e15a0eeb973092533bd287612d90b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74a3bb546c2295b3d9895ae81ba1e1ed396298c2d4d6b9da7f4d9da0204c367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85fb728ab33be820ba5a17210b0fd432e4c0c92337806d6bf72a2410e9850159"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b118e54e7e2b79b86af18f12075cc4aa244d4d717071dc2f8ffa9d91c320eea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ffa4ba5526e0c79cf0d0e601994708be93ce606926d8c858e85757dcc338d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c271ac992f25e0f72783f34724658784671d69b941cb2cb65123cf6ba8e219c"
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