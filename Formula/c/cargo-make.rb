class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.18.tar.gz"
  sha256 "1aab617a63ebae03dd4c979cd884c31a7afa7a62adefaa95ebc214d23bbb888f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd26756d93914b76c0e65b79f8926e65d65b9272bf405e64c113797f9f0e707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4074bb88e11de9157fe3955ee2d3284f38ac6169c108544d52d706e89d86927"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2449edb81ecc0493d0e2bea4fd04b5489b35517681db5cf60d67debb0d443eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d159e621d83f007907e18a58582ef5aefdf2698713ea895f7dca67dc7d90a360"
    sha256 cellar: :any_skip_relocation, ventura:       "e45cfac4b60962177b5bea6458919e87e26be265e4a4c7b4c5de8c3051614abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509b8b202e2b592d077f0669df5c4dfb02bdcf2a57a08c4071e46f7dd66b5fb1"
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