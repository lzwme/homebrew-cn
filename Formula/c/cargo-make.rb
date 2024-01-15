class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.7.tar.gz"
  sha256 "5ade7f3d882d28a8257711c4825448debec11ed67e64a5719b4fd4ab08a6ae18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16ebb56ddafcc9c8435600105dbb45f80ab9040e999fcd5c93fd4c15e3137f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93ac2d09b4f04d8523d921f9319ca5f3033d5945c470187fee8877fafed490b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9269c6b32fac4d86c209b9af3c5891a1fcf405cb8ce26bfcc185077e428a6e23"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eea8d6c37de4540dd4e45a98cac701caadb72162c8f08708bbc831a80b9250f"
    sha256 cellar: :any_skip_relocation, ventura:        "dccde81221d1931c79a209a9a4dba490645e98dcc8328c331312458fa2c6803d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9574f9e35854d307958b2b5e4d3fc7f23c4ce3d5044703ae9818bc636dbac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99cbeb3851ea4839cbf68857b0bf4ce52dd38520a4b4f317d6dedef2f7798a8b"
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