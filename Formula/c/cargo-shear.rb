class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https:github.comBoshencargo-shear"
  url "https:github.comBoshencargo-sheararchiverefstagsv1.2.8.tar.gz"
  sha256 "9b03269633704ce8e62445e389170feef8d269adbd37f0758cd0106a18ab64ec"
  license "MIT"
  head "https:github.comBoshencargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a9b306a0caf48c0b85ee99e089c747c7548fb5af3ac4bbbe09d967c9ac9941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c905d2ccbfdee557480ec340d48289748c9761e9df544b620b66ec404a2ce79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bddfe24fbcfa4c0b98a5d77629366e6d0c1e004068d922d372bc2cec0dc41ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d2655ce4c074d96893c43777387f1420f58a8fcd815a759a8f1775dced05a7f"
    sha256 cellar: :any_skip_relocation, ventura:       "eaba18b8ebb1e809466f480c45bd0c8a59df5f8ba2edf9f0b16fc318579b015f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e32b9ab56458425fffa2bd730d85c0f26064efb03d871522f6da9291b95685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c543a23300efcc1186dff402d92508fe060fc91337c494e3f91e60b3da37a32"
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