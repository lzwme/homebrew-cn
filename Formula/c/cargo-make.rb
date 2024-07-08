class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.13.tar.gz"
  sha256 "4d2cdf575715f19ccc0c362244f1d2f37709866aa4c147b7d282c047c1ebec31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e0eddb979513cad595e2e822071fa8340b5976b250feb99abe63c57723ecc36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d5b20dd4b876d9833cd23543d9f1cfac31c6edcfe302bba21de4a3b30459bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e2d2432603b1c8196fcd72413e013040006ff3755714a030ff4376a55c50e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "eae86a664b44b8c104e66b8720eb4b5d8d003cde8f18eaf61ff839a4d55d4651"
    sha256 cellar: :any_skip_relocation, ventura:        "9f76e30a2e6c423226ff9cb2be4fdc2d85d5b6b993aa7db9a5700c5d12c0eb32"
    sha256 cellar: :any_skip_relocation, monterey:       "ed5d2d9c728b3daf4f8a30ca4308887bb18dfc2fb462950ea0bdd1faa6680005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6ca99412c7fc44839864fdd51aafa3d8df7d34898f9d122b12d012c6863482"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    text = "it's working!"
    (testpath"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}cargo-make make is_working")
    assert_match text, shell_output("#{bin}makers is_working")
  end
end