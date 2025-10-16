class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://ghfast.top/https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "ea7bb377bebe0ebe860402db10e3233d3c8fb6b7ead078d4308b5d4ac86c9222"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e0eb7e11bd5da4028b6414714b700e759ccc83252035290c2284284711ca94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bedba5163d1c7fe4c6b4019464737be7340f27afc8fa47b18a74cf148b5e362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39f4a90916766bee812df4eba170674f7809ddc155e7d9ad01517269969bcfae"
    sha256 cellar: :any_skip_relocation, sonoma:        "55535869e7a07427af315b94881ff2443760f1c76f22ae3930868c5bac4e139c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "753548da61bc46030b73ca3296c044daabf7ebea268072af8241bbd7c544d757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1b6249af373452db4b5047aa4354546dc08c5d3f69e21d097ddca208ba00148"
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