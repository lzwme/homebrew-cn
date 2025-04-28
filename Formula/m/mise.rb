class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.11.tar.gz"
  sha256 "8bab67e98598f146ae35a0cdb76e1dbfa5271976231e2cb20c0b48f95543ba15"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b025e56e3b2d093be6605c2817082fce15f8c30309e797071e14644ead523cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3502d095c44d67292dd13b5cf77b0712085334083d31c1d184e1be67bad8fec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9837b5b34fbec07a2324a96794119733d2d05f3c86016c79483cd87d0a62aae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "77fb54b72c516c62990a21b525308b0b55c51288dd3491c37903b07faa45e554"
    sha256 cellar: :any_skip_relocation, ventura:       "e4d61dfce407af0bf81d983a17d6a9557ae986c29ff4f6782937189041a14f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbab7443dfc866e9b9d6a687549429674b60d8f839da34adabd5fe2a43f1b21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3379e43646e59eeed577dea58bec426d76da351f54ae88f89b2513ef03584584"
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