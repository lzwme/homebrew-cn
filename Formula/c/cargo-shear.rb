class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "a3a8c288423ef5fae7d1391da4fe22cceac0661925e65957b4fcb4d6545a93de"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11844d2b14613d4627695acf97deae20166843b545118f15096fead3b45d22a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4269f5bb4814bd4a8c1d9253b47c3f3c1c08e801cd184114faf7b0fe6e33f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "579dc3a64e9606bd9805d7cea44c9ef4b6d1adeeaec35501d701d9927908b20a"
    sha256 cellar: :any_skip_relocation, sonoma:        "165803c73a46bee59a95f731182ed3e6548df696b2f55ddfe5ab61fe6eacabac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140824b9ddceac05838bcb7647cc78e7c7c4445b57eb036db3522666a765d368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635333cb073244448a5be20beb527de13df8c70ca97a69bccc59506cebd77ea0"
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
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          bear
      OUTPUT
    end
  end
end