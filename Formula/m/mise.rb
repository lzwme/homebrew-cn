class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.2.9.tar.gz"
  sha256 "a910298c69a1f374cd39b58aea269638d558f403ac811c17115bd83150bb57b4"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2538cb195fba640b5577282f18f2248825c0a241d8ad8eb959b26d49cede90be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8453e62846cf256863cd89037693a3f852f97a592a055877a2d5cab8754b83fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bfbdf29fd25bdf6147e6f240b120d5a7c9e6b1398fe9e3dca0262af370d0729"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddecc5452a80b24a49897c61f9f6cf76750c7853840fe7aaef73951538b00b9e"
    sha256 cellar: :any_skip_relocation, ventura:       "4ae6abdbacc19fadb4dfb02c3fe6b306ef57d424e289719b24cea37216624ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8561d6a6e7073618f5673aecdb24a170d11bd3a75c5aa53164b13358e66188"
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