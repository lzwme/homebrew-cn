class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.3.10.tar.gz"
  sha256 "6a0d3e1d3c6d84070dea261bf851d402588ef5a0428a2d917f18550dcd396a7e"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7541f33c268ee174963afba625f128593b7ac3c01a1461069c43d7833df09be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7d5723c82c280ea0c40a2bf2efb3f92b0e200ec1002a3c55c67c8f59e7749b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8581f67f38d28592eae79c98d9bea5d86b80c8d751c961ce757c8f67e96dec56"
    sha256 cellar: :any_skip_relocation, sonoma:        "776b88ee17a13e7a71df4779794098047908ec620650eb3241cc2e78abcc6435"
    sha256 cellar: :any_skip_relocation, ventura:       "e5ebcc365e90c5662d910f9151b264cac1315878d1c297f2ec1ac60ed9ac19c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdafa954d76f9a85c222f063dd40359d86e32225855d162b510f46d5e28e3972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e2a2be92e6f29e0fc42de4c835fac65757b4ad3b1a74a65fdd6cf4ef16cecd"
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