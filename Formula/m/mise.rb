class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.8.tar.gz"
  sha256 "38c2061303607543507474b8ff0b2cad979f1f4524a03ed854f5e656e1be654e"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6299ee09fdf430bfdbec42d3c0ffb80acda374452106868a94952325e33f897c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86bffef9a111b50c9de4ccf2bf9c8c13195c6681c680e10319dbfadab0605672"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7127b01c4b67dd6b7cc8b1e5572c312759fc4b4884da6b74fafb0a9c8377bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "68e5dee494afadaddcc3edbf239ce2220a8bdd028c1fef6d353d35b484e12a1c"
    sha256 cellar: :any_skip_relocation, ventura:       "c6b1c9d0ccec7c3f78e7bc78465aa9cee17c741e0ec82ba8167b6c68d8ef5b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0397014b469ea1e209bd1869c7c07b66e769a306ef965b0bf8d9ea8454e2d3e7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end