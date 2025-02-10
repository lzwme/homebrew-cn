class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.3.tar.gz"
  sha256 "86308e1fe9cff9b28c1c15d9c8fb504d455c72b5c5927db8cc9bf62ba62cda10"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fa40641c8d73635910bb489bb1bc80b318cce40c30117cad8912070b0f11de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbc36b0b6c7032574a2b4281dff04b179eabe2522419a1108fd7e6982ae6e79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a674ccca63c2be845f9b8cef49d0f2f7d5e791446fad4ea1716abc0204c0306"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef5c852dbe4fcc4ae9c0f196bd22826e44da4132516d919063bf302ad808aefd"
    sha256 cellar: :any_skip_relocation, ventura:       "5365af1038df57bcf4b74ac176be244d116ab2162d0861fcc963546c19ffe7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1c29d55b0f319e070b6192aa80356cd4f82961c9bd2d9ce149bcb6e06fda19"
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