class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.6.tar.gz"
  sha256 "8c2ed9980219fb139ef974fe34f09108eb923be720cd606b9270ee316defc445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81eede938316046df8e789a8f557b7e1251ef500d872d6fd493b1d8e7f3f680b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "209e343ba3b40339278dbdb12ea6205172b0547c1b6bf8ae97b28e5b6b90da9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35f54dfc949d515bac41cd0da1b33c2a148df45c800be6f87025b5687a393d0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "22264a0052b56e0dfd240227cb4ac78e4069f9d472cdf68c9c7bc912fef71547"
    sha256 cellar: :any_skip_relocation, ventura:        "706235a91fb3006c1a63cfd61e8840c322efd1200a7f9cb523e124a5e44ababb"
    sha256 cellar: :any_skip_relocation, monterey:       "278f1b6a43c8284415e39c6271d01be857eb03c8a23e70b1c0cb065b8b87a0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0957717d2c12dc9af3ee150a0643295b0680dc0554d4eb7286bdc100ec10630"
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