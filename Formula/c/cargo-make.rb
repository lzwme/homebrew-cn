class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.14.tar.gz"
  sha256 "954ba24bd4aaf3e731e8bb4601e94cf491397bb394c1a71ef0908530477b62fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64fed894bb410c8b78ce34a7567f2c17996689a028a2e6a8d1d88fb83ba8198d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "145bdc0e204871e5c553302a49471e92a0950690ff740de9dc3e2ab5c686dd2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d25e57873455b589b92d8f1061efcf4dae0693493b06d92adeaa83541d2251"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d3e938dbb15045736b75978cb7314c031576f4c58c98ac6b7fc83cdb749669b"
    sha256 cellar: :any_skip_relocation, ventura:        "0e10d0a62d656090e24a6b304f9dd666d11ee040c15cbbb3e222396d8e244d58"
    sha256 cellar: :any_skip_relocation, monterey:       "fe525330d9cb76dbca6762ecddcf5a3a0cbf84e6ad3de68581a530084458fe84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69bcd4fbcabc13bd7af8cddd87a92be2dca2e976694c4406645b194029511ff"
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