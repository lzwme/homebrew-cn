class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.16.tar.gz"
  sha256 "bf3e46b94416f8c426fd3af41c37dcb015d2b593886bb2eceba8cc0def39f1fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dfe95fa630b7e6e21ec9ddb0442f96420cc385170ab50f101069ba962bec328"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb436f9360c89158122188bf95f8ea44aef81bb6b086dad7edb2fabaf7508c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c57b1110b8a7b3d13e9422724cd6b8895d4591c0761bd996f75417700993ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b5a2d2783faa25916916710c3765869b9dec3e4212b77c552a5c0bebd152a12"
    sha256 cellar: :any_skip_relocation, ventura:        "2fb182684e7cd31ead508eb283a01d89eb637fd87d87fec901ed938357bb6eff"
    sha256 cellar: :any_skip_relocation, monterey:       "20ee8d085af2b62c6895265ece1b0796d39a33542cf9b901be3f207e834008ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d35c8302a3b7b94a32eee6d592ea4d2592a9cc891b8e942b483e8492a11a955"
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