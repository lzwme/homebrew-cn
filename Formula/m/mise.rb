class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.7.0.tar.gz"
  sha256 "ddbb548d2f4e5d27bffa11f61747b377e029939d62f49601cf291409f1d84d8c"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c3ba509c3a732e9553169b556ff60bbb0b958cbb9f1833903c75e58616735c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6869f7f8f26b2b76febf5097fc0073d32dc48cd1f7f9753d6357f11de9ae80c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f94b5d27ac6f49f416b08d46b8de1027daa9e8de51a4df4578e505a9d35e9a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f0995f4b9563350b36059b72b6023036fb3fa4539352141d8161f6e525982d6"
    sha256 cellar: :any_skip_relocation, ventura:       "218c38f7b36d5560a6550f60a101011dfa3c5c7e2409d92dc98674446b9bb4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a02abb9114ec72e525d07de565f83ef35e37f1d657a3cbbb15231d31c37c2f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "728418d9381ed4743b463c23656e6fdb97459d93952b6c161a26bfea1d1ee043"
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