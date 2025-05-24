class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.11.tar.gz"
  sha256 "2a16016c2b844373e810e1bd607401e7c294f733e0a927132aedd6628c1b5cc2"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7db45a5f0436ba0ac8df68e28f7ab1f98daea621fa863b1b0e608039b161146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34483bc7a851a333efb9ade303bf3f4083b1a2390efd558e6100181939245050"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94bbdcb02440d29f153be7f8d7095071e11883977c00889074d6a1d8f7ddb0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a28ee4bf532adfdc04103b0536b359913eee902ebb1a25ee65727443fe8878a2"
    sha256 cellar: :any_skip_relocation, ventura:       "bda9e4410b6048a8a004750124eb48f8de088ee2a1039766cee1c3e9c432baaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8771c2ef480a6a28ad6f17df90453dc5b63f5ae3b586bd3077c9f38749204d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb07e6163bda60b4f4bff82fb4e4218c3cff8bb3e3456b3b4abfff8c8756a26"
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