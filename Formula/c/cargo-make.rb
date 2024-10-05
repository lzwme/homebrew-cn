class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.21.tar.gz"
  sha256 "08c3674d6a55015a388b49d3852e81464f4ca544400a37ab7b3752195fc503f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48fe3c7c121f658f7181815ffd63ab41a3bad28d95b6141945c7201763e4cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb0d6f9519a07e8bcd2150a83a62ff225748d30b196441aaa81e97decba5c2c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fdc0462ed5d1a58ebc9cffaf323a5f63d6021fc8f050131afb0d128c92e7842"
    sha256 cellar: :any_skip_relocation, sonoma:        "d626e92d2a98ed61a3f57ab1d76f1238d114f3c3abf9f968bbc2ea4d241cc549"
    sha256 cellar: :any_skip_relocation, ventura:       "7c287a9a531d3f389fb4fd429276dcc1d929c39f540207aa9cbbc2bc2cb593ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a3f0f615238eadb961a08f213d3c32234d770ad34a9212a74273ca4543083fd"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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