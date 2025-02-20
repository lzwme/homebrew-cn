class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.3.3.tar.gz"
  sha256 "583829ba1c025186bf3dcd79b7e3d3cebd20d4f5a5a1a0cd751366723ba1b812"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf79db827d41fdfb7d7c3928cd28248c36dd96d238152b7b1f86150f8dda365a"
    sha256 cellar: :any,                 arm64_sonoma:  "d0f061813132df93b6cf16d2098771ceac632368eb2833ebb0492cf1af8cead5"
    sha256 cellar: :any,                 arm64_ventura: "f1b435d63ef284a234d30d60526159b51c8f35cb31c16f8160c414e527cece8c"
    sha256 cellar: :any,                 sonoma:        "505c57230bdc8a09abe760b228fb8eabd7d1ab6c2da8e8471c8ececcd73f6eeb"
    sha256 cellar: :any,                 ventura:       "87e7ca5fd3fed1778ff85947505a167fc970c6c230960b4ae104996a2aba7df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6196e62b8055557af930699cb4e8a10a036e7ccf14ed138ffc66b5c9203dddd8"
  end

  depends_on "rust" => [:build, :test]
  depends_on "usage" => :build
  depends_on "openssl@3"
  depends_on "pkl"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"hk", "completion")
  end

  test do
    (testpath"hk.pkl").write <<~PKL
      amends "https:hk.jdx.devv0hk.pkl"
      import "https:hk.jdx.devv0builtinscargo_clippy.pkl"
      import "https:hk.jdx.devv0builtinscargo_fmt.pkl"

      `pre-commit` {
          ["cargo-clippy"] = new cargo_clippy.CargoClippy {}
          ["cargo-fmt"] = new cargo_fmt.CargoFmt {}
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}hk run pre-commit --all -v 2>&1")
    assert_match(cargo-fmt\s* ✓ done, output)
  end
end