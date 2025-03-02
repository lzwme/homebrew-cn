class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.3.0.tar.gz"
  sha256 "8b8a325250018403c48025aae340e7cbef4ec7514ca2a70dc7c336abafec7a30"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac19b8044c8176c5f569801d8f56411ed55548fcc9ae4f376c50d18d6696af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81be7fed40b66d94d89b57c5f525cdd55e7a1f23df8a21c8721e93e5b2aacd04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c9d7a842c6149fe9b86695a46a536d8ec8207f29893c229cadc933169c92e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "1098709741e484ac4d26c318003f2f9959ba031a923b17ce2e6f2f466acad3c7"
    sha256 cellar: :any_skip_relocation, ventura:       "09acf020003b877507bddacd8f4638695cee9d3eb50dada2883815a517c7873d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ff1135c15b3da35da4b8c0f5b5cbd8eecd8eb119c728204c308f85d2392800"
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