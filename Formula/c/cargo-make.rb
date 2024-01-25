class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.8.tar.gz"
  sha256 "d2c68cb112fddceb316b61c6421af93f5060356e2c83f38c28aeb12d0800e281"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "247199fef2aca4375a41de18ed09d8c5f60a9b4e041bc9950e2d322912b6e6db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9312365db350fb41501674474905a7c00af2909fa4dc00ee0a3dacac807e859a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db5fb813db1d039ed74c77d4f3f456b9bebaff9c31140ea2af187de3e84d8c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff8e4c987478ec4e51fb4c94b18dd870cc0ba976915cef49c233b35f0039e001"
    sha256 cellar: :any_skip_relocation, ventura:        "9f76b4965b17bf340b3fbb6402888088ab7bd1a8c91c2e5167e2921637d0d319"
    sha256 cellar: :any_skip_relocation, monterey:       "feda9e0d18a5ff3254301178b813bf579119af081767d6bf5f380fbee69912f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7cad7376e161cfca11fdfbd2c802a85271b83c409f1c0d09cb2cb484727bd1"
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