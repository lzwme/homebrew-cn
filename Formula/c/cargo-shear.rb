class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "73e9c54f13725e00228e43babd88b60880cd477fcd2197918afc2a4e423611ca"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e57a2e89eb99fec79454aded9804bd1b36a60c98203aad8e8d6e73bb6b5a120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec24793bf8e3770620be3ec20caf190cf080c42a73598227607668694117109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25a73efab9fe9a568401c77296992d2eecb55221a0303204369d53f1d9ebd9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "953aa3385255805f042b3385f5f255c1531779b3195257996ecaedb9036030cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ed4f4acc813cb23bd1a42b7cd7262d20887e1c0a223ca85908353adec74ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e5e1cd28220705e603562fcd690829db8f0381858985012a449c3a0c184176"
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

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end