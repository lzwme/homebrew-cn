class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://ghproxy.com/https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.12.tar.gz"
  sha256 "3b98bff2309bb99a48ece36afe83807441c0c2bcdee78a696a53ca527d78cc74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db87e92c6a6386db4fa08b42242fd099290a6835d2df1ac15fe267fbde5d0e94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "382292f9cfce495dd3a0bbb4de6efe43de7387bb9d1b0eddf4153b5abcc0c347"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1aa81c61540534cabd724f4aaffd97d09f3e1d546b5eadd36e9e282ea744547"
    sha256 cellar: :any_skip_relocation, ventura:        "71af5828ef23a0c14151b554f57b34054ec48dadd9c4afb3614bde9647f16d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "8442579a7e1e84bf724811b4f1f41df3406ac3c8f8277de73e08f57d8616650a"
    sha256 cellar: :any_skip_relocation, big_sur:        "615b243e4bb68688a68323d907d9fbf843a4054bf2191db57a44b1652d8444d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea4246f4557a3ffe8b49809a6a7bae246a1e5fc3e3ae20818ae8f67d3f6279b"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    text = "it's working!"
    (testpath/"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}/cargo-make make is_working")
    assert_match text, shell_output("#{bin}/makers is_working")
  end
end