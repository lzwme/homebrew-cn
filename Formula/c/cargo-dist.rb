class CargoDist < Formula
  desc "Tool for building final distributable artifacts and uploading them to an archive"
  homepage "https://opensource.axo.dev/cargo-dist/"
  url "https://ghfast.top/https://github.com/axodotdev/cargo-dist/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "7b0789247612e83bb1bbd459654bd22f8bea34ad83f11733f853af91aa05f242"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/axodotdev/cargo-dist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa0042919dea2fd6f987584c5f47b4e8fa7fc5858a10f9b0276894f0ec8852f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01eee0292dac7f0086b9e55db13df8ea496a39f8e5e9d4d94324cdd100d886b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39a95618b1fbf2cfcfd3ebad836bc2bf9285aa934ddcbc8df3ba714c6226f64d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab5b5e4a80c8d8b14553ce1ae3e0a9beaf8e318ddb8548d3021f61e5dabeb1a"
    sha256 cellar: :any_skip_relocation, ventura:       "1180eec26d7cfffb446e97f936ccfffe0389e38d0d1bad800759255d058f21ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5462e56f446d0baa7889076c586caf9170ef5b15ee03d13848679067e95b184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7420eb127bd59956e733fdd242c411212c68afc50accd5bfe6f206b35480fa7b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  conflicts_with "nmh", because: "both install `dist` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-dist")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/dist --version")

    system "cargo", "new", "--bin", "test_project"
    cd "test_project" do
      output = shell_output("#{bin}/dist init 2>&1", 255)
      assert_match "added [profile.dist] to your workspace Cargo.toml", output

      output = shell_output("#{bin}/dist plan 2>&1", 255)
      assert_match "You specified --artifacts, disabling host mode, but specified no targets to build", output
    end
  end
end