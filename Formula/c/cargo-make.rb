class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.17.tar.gz"
  sha256 "6338725e9910e7e579143ad4d4dddda950c2ea7244b747d502f8bc27af267333"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f358a30e13066704a369e2b0c2497c38070854b44af6d529d37ace9601c5f4fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bed2ebb1050021798ed4a7c62270e0b2f6e27b86428c65ab167090f4509f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4436d9f012eaf5bff70f995878c0d856f29e9a5353dd58c0431cafd5eafdb405"
    sha256 cellar: :any_skip_relocation, sonoma:        "649d48b81aace3671cd16abb689ffbd7af2c091419c7a03ae5c3e7024b9048b6"
    sha256 cellar: :any_skip_relocation, ventura:       "27087e81249a4637064355b6c8d7c295cc66530af9482a0670aac602630d9b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2499c9947652d6277f864996571dc67c20b361f5c2f432514137ad88e5eb648"
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