class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.6.5.tar.gz"
  sha256 "34d43dd19846caf1bc249b7ef3d8298df48df2b95727a6e9695a2ded33c1c067"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e5aea9bc0f0edbba348e2b1d92b1eed4170141023bea7418249f80df2a9508e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1766fc7afe2ca1c9973c9e286c9cbb2339e292d897e9771359682887c6b95d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d21bcc8c0f10fc701e697ac52fd32cdaca8ec56118c6b30d98edc57ddd841559"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b28ded123770a73bf9f411d146fa967799a881f5d74c9b923c8a2f8b6a0b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "373c457a1ec0d23b3ef36f70495aff7e8ab7811c2a4f68a47c3557782563af5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c34df4f6f292388ed873e591b69f815db25bf46e2443e8f33beffc6eb9c7a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dedcf2e6ff729a28aaaa5d632f1ee3b4dcc143808515f684ce115cad8984824"
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
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completionsmise.bash" => "mise"
    fish_completion.install "completionsmise.fish"
    zsh_completion.install "completions_mise"
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