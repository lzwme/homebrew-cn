class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https://github.com/sagiegurari/cargo-make"
  url "https://ghproxy.com/https://github.com/sagiegurari/cargo-make/archive/refs/tags/0.36.8.tar.gz"
  sha256 "291067dd0420caf9c5c865217bf66971f773c230ee0814a58c4ee44277e13ce3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67de4ced3f063f77134fb0fd8f973301912438c4e3a17fa5fa91186aa35a5ba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206340b82953fd82f1fea0e85f3f54b0374e00f4937e01937f4f9948cdcf3577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c0f6e494a33ff8af5ad783eb8f93915e3538ee74113156650ef4318a654416c"
    sha256 cellar: :any_skip_relocation, ventura:        "89489783a35c7bf09945b13a225736701ab167885e70afa2e888ebc31cd42a04"
    sha256 cellar: :any_skip_relocation, monterey:       "ac98b2e8e5bf279366af97d962466cdf10c7ac44772feb91cafbc41ef3cc8c30"
    sha256 cellar: :any_skip_relocation, big_sur:        "b19039c30539f55da92340bc825be9f5f7b5c91073dc4e33f60cfc1a0878da8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4315e693e10563dc0b85518196a651c9a27a003665a4168a03092d9af03be0bf"
  end

  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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