class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https:printfn.github.iofend"
  url "https:github.comprintfnfendarchiverefstagsv1.4.9.tar.gz"
  sha256 "f0f13932794ba8da32e54de923878b44620b15c6a206017502faa54ab881a33f"
  license "MIT"
  head "https:github.comprintfnfend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "003e7c9718c83e3dea803854035fe85e3aa8344189d716d25dbbddd7810d8202"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fffbf27db6ee9bdb4a9b1aeb4e0dedef0a76f681271b0415ef295f95fa8800a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0309ebdc95f678321e4952f55cb5872ec614766ad6fcb89bc77bbbdd8aab8bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecc82b072e216ac675711e35d425360f73d2f4002378b629d9fb21e0108afd6d"
    sha256 cellar: :any_skip_relocation, ventura:        "74a1ac7b7c68f082d64961b8012ec5c0788001f4fb0845aabdbac1e3e6d53a12"
    sha256 cellar: :any_skip_relocation, monterey:       "27bba3a2c59b90dc817bda3793eb622120a9c10e012ac62892dd7c01e0a896a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254295065ac6fa16dff772d295a6204e07027a3b5411eb3f4db062175a6458fb"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system ".documentationbuild.sh"
    man1.install "documentationfend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}fend 1 km to m").strip
  end
end