class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.1.17.tar.gz"
  sha256 "82539d96cfd88edd8f05f997ad410c075f03a9406f479c0290dca7fc09626bc1"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7124e7312e27ee71be8829761785f4c1f587e3f4242f054e1c542231a657d7e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19e964cbf2f66c19fa06a27d3ce37ba96636cee19c016edd78c659eff46fcb6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f72d928ef58888fad8f7f8d64cb7ef54a5a746f9bd68edc236801602220c576"
    sha256 cellar: :any_skip_relocation, sonoma:        "add85b61444d9717eda5b79e409f58444158a479fc8596a4560707a9c62b7519"
    sha256 cellar: :any_skip_relocation, ventura:       "06ceb3f799206f9d4c0af5296c87cf101a1941c34ae69ce7e9e287dfb28a4fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d560a08a777f8abd3dc0a7e2bf58e38ae6bfcb126405f0ed5a100b9efadf765e"
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