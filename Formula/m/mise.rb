class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.12.tar.gz"
  sha256 "4e64932ac40f94e436c3e72f3341d9f15a34d212efe642278937de3d1c1d74a3"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e146fd2b676c3ded164e2bd31edb86494556d497f56d65694daed9cd0d1e55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e333a8d6ffb4c202e52b493d1d4f9bfc46971ef4130cfa1ee9eb5e47512e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47427c1eac03c47c0d75a940c695e03ba25f511e8e99bc21b095d2f818bd2c59"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b70857fd241d486c8666c8af674a93e5bad6dd133c015840cf0708e45101695"
    sha256 cellar: :any_skip_relocation, ventura:       "1ea311f8ed8b8b2140c8ac6a0f2b7a0436ae4cb75006a45d72db4dcd6061dab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b719b4a65e79792d8315fa2199716de09283c4b34e4bc35834a59fcc5dfe8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bdae7837da1b9df682d683dec7846de11c2eb33bbfd756814fd617ae2dd5c39"
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