class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.15.tar.gz"
  sha256 "a0e9426865db306012dfaba28d482cc4e9d27a29fbb648e8541f58747995e363"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157424573064575cd8c2de45f90fd62609f10b5e1f697b2078f129609ffe99b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c0225347615f08bcef59a4830d334fda2eb766e31ff88a141319e4c5fcd5955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d395e02f9c974406b9bb71d2874f2a0b26306aa17436787c3f75b6172a9c4508"
    sha256 cellar: :any_skip_relocation, sonoma:        "84680c90c5c7ac83e526fec975d4e5b4c372435ff5903d15423cf3662eb6846a"
    sha256 cellar: :any_skip_relocation, ventura:       "57e71e8cdf3b2cf706001ef19e30217644cf4d294be5dc2e97ec29b6da2bd9d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9f2c920263c65e5272a064d98b4e6abd39ef612fb4ed922e1ac704728f80da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30253a3843fd171ddc229a659d3b247dc1310c452a66d58675e70006047068cc"
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