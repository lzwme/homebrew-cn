class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https:github.comBoshencargo-shear"
  url "https:github.comBoshencargo-sheararchiverefstagsv1.3.0.tar.gz"
  sha256 "46208fba3ed2213d1f62a5098a7558ca0ccb4b7066b47a039748f190f11a93dd"
  license "MIT"
  head "https:github.comBoshencargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c722ec26278bd2652842e39962a73e5827f29131dcc18c4d0a66fd71f534126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c16539a6c3962191a817bcc881cb416fa75164ef88df5296da0b99ef0f0791"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72fabbcacccd2512a8b1749e775bdb845f505cec507874344aa79f8e8f7c3c64"
    sha256 cellar: :any_skip_relocation, sonoma:        "10fb9e24880857b72151b8f7da4675b3f4b5d1f18e770061300c06a3e8165259"
    sha256 cellar: :any_skip_relocation, ventura:       "66202e5ef518c5ed3b502e5a620dabbefdac2d0b4a86b1374962e88b53cde624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a64298e09b292b383d0a88d1f0272a5bb96bb23abb6b56ed746cad5388e119b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802d5e0f8bc41bfdc49869208ba41c27c832ff6490edf75e47dc60f0f94976bc"
  end

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
      (crate"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate"lib.rs").write "use libc;"

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          bear
      OUTPUT
    end
  end
end