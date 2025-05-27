class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.13.tar.gz"
  sha256 "1f0daeb1356b2c73a35acee8adefe62a8b0e76ea0ad18656d2033c8e7a5abd72"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c30055aa806f10047d740a17fdb2cb8a2fc07edbea9ee6c0e84c5e39e27118a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6153778f7605d5e7a1f6ba44e73983b48c93ae6fbcf5b2fc4c92954990425d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "069b92cd865a0726ee09dc3c54febb4c9a4fd01c60d8a1685905d1de5701f851"
    sha256 cellar: :any_skip_relocation, sonoma:        "77de0b15d8c3a8253c60a5ee8b7bade9e55167320ed690c42e381c38d5650402"
    sha256 cellar: :any_skip_relocation, ventura:       "43b2e1ee9bb0c5e9bc1d6513f3c6122a67b9d4bea9b217e5723fe7fed930fe3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2ef77f82223a42e816820f77af063e3462d4ffce48dc5eb6e2c05bb621420e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b61f7e2168ce14d339ca3216c874f9703122ba8941c86cb96caf47608618a7"
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