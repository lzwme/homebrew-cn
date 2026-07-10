class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "35dfc75325882b0641439f72982c46dc43ac9335093c1135f0078fa2bbf6647e"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c147edb7862b8aeb8cddb039dbfa2f4f27c2a13ad7c55f834651c13c3f230a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125c4f30c44862e23ea0ab6b9ba15fd5b187c1141d9ce58483f27e15474fb134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8455badb1e30df42c97a78ad5431ed38841de24435a28d65be4abfa49e11a0ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2aa17c0ebdce8ae19456c80a3c6635b0c1c1713b150830bc59591d2bf44a9b"
    sha256 cellar: :any,                 arm64_linux:   "1b36c78a37dec6ec1ac97ffd4819f9014bd907eb4e44fd314eca7a18c8083ded"
    sha256 cellar: :any,                 x86_64_linux:  "98c92ca9b4457dfc227e11e1ef49ba4e07b73079ff04c2c6e198ef90df506f60"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end