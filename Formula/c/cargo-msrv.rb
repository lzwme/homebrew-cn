class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://ghfast.top/https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "d287d3d88194c209c30476accfa5074196f28996d14f53126218e90670a78890"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ecc1d1091f2142b0b0075d5357c457e01ee7cbaa1d2db305720d339795b02c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ec80dea02a1c1bc67189892d3955d9f2fd66b44342b43bf6f4ea018adc5fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf6ae4369f7e3df94b885841edc5c1c1944aea0de8a1652be7c911f16366d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8021066101bf31ca784029352d94c543ad868f36b5aaa342a95b60f925a92926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322a1490459e7bf51385b639ac1e6679b0a82e52fea97d7d6cf4a9afe69f2277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37505e01e0b6e535f8f52cb00f80667a7bc416671bbb0ca767da85cd8b6bd78e"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-msrv --version")

    # Now proceed with creating your crate and calling cargo-msrv
    (testpath/"demo-crate/src").mkpath
    (testpath/"demo-crate/src/main.rs").write "fn main() {}"
    (testpath/"demo-crate/Cargo.toml").write <<~EOS
      [package]
      name = "demo-crate"
      version = "0.1.0"
      edition = "2021"
      rust-version = "1.78"
    EOS

    cd "demo-crate" do
      output = shell_output("#{bin}/cargo-msrv msrv show --output-format human --log-target stdout 2>&1")
      assert_match "name: \"demo-crate\"", output
    end
  end
end