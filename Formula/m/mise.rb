class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.0.tar.gz"
  sha256 "b6d3286381b504ec4138d038131d58fa7d6af380dc429cbf9e894260c931831e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2fd4f90ad08b6f71245be2fa226a60edd98f2995dd9dc2c62582300eae42c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c5a24b80910cf608832c4e3bad8d070f75c75a3043d57d0812835393062f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12cdf814a158107e061bdcc1c39abafa418a909f3fca684f8ca0366b4863d512"
    sha256 cellar: :any_skip_relocation, sonoma:        "767f5a9edf41fbdad6af557e0a6aaab9e7ccca2f777988b7fc140dac0b858fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aed785a59d4a9a2ce6c80c87e982871ceccf90bbd2e4f26ff3250dcde246d351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e1453e026c0a780edb004eb31b0e7a10317c2e00a12b260b6d78a71b8ed6a0"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
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
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end