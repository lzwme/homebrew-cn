class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.12.tar.gz"
  sha256 "bd50c240355fa2d975af0069ee8b270812ebc39267c542c63f13a5877729688c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a714692c3f0a90eeaab11c834374213a8288a737836f65486cbbc3050b5b062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d46e61a6e57b847b428da511f6991c4ee3bb4cd09ee4a60c5a6c02acff58ac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65d1b13b68ab9fb24ad9e2c2198588591d8b33071b4b7e7a9bebfe3b2e07c54e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3209c46050be8e468236348c3890c031b18d92adddcc99a3c8d02feafac9f592"
    sha256 cellar: :any_skip_relocation, ventura:       "5e941e4029dccd48e76d9263f97922547f5118f2d01f87d633dba24b7c81caac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102571cc315994b8d95ae38f5813155296a1c83bff749fb4069d532eb8508814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52a655c0d50ee335d853c78472561c4b2d5ce1de24de165ee74f25a6a1cd804e"
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