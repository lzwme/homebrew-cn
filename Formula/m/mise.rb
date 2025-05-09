class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.2.tar.gz"
  sha256 "7f25802b23c229a1bc0c5d63723fb8acd7a3781c888cbd81e04e0ea3d3476f9c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7808861ea94a0198da796d79e4d49f1dba7a2ca0d0967a22e33755501aec41b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0258e28d246558a8bba2f66cbf9d793288c58e5865b5def91c8ec706a58a6911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d31c366b75090b2dddf6d8e6580c0208c9620571bed2c58274c4f282d9d4173"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe6b3c4137754bb452608f08f16b01919c1b080311e3bab97100a69c9113727"
    sha256 cellar: :any_skip_relocation, ventura:       "84896f0bf24b2c501e9d24357ac2405d9e0a2f03e8c14cf8ca018b80ccb23f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42d4c3b69f9c89a8186f452b8353c60f1c2ba525e8d4621739d03b418db058b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c52dc2f73720be27cdab24a22f9a0f4dae04319355b13620f1d31ccf482314"
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