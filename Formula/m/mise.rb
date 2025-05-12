class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.3.tar.gz"
  sha256 "0f2a627dc5a6c3a859c05d21dcecd50a26f2fcb050faf3dba43c8fb0c6b4ec8f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2053354aea761f0d80e9e56699c729fd131ca92560f80a11b1847f846fdfd305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60a2eda542291d0dcf069f6831041c6d7ce669ddba86bfad079fe374b879f6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "532c31f390fa8a9bca0c74abc4a63ac54f66e144c4abf0eb0cf67dc009f24407"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae69bca75ba408a9b35da70ef45fa51ddd67559c29241fd5a6e99e964fd3eab1"
    sha256 cellar: :any_skip_relocation, ventura:       "8e5581b4bddb12b23e51b6512333a198e93b45352a88f0d6414631a95e41f9e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3338a36c4024daa8ea859756ef463811ae6b095742b97030604b22ba9ad560b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "379632610bbffe7c7b0f17633446322cd000ce330df11caa51c61dfd4ad7578a"
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