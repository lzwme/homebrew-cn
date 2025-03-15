class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.3.3.tar.gz"
  sha256 "e82fdc82b73da64843ad3ebb9c00fb010c538679ec7ed00a1a9fff492f51dd8e"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f559f02c267e645c4daedb5db45c3d33b1926fa2f94f1c67662c904a90077cea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0103d91f783de03ffc9c13a5f86491c809c0bb50d444f36caee88b6b1c0ca49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f45eed46913aa06db69e845a807abf718561d448582b03e9a2308dd32e9bd0f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f93e8ec13b4bfcfc2f64d7bb48d89a8021a5bfafa6f3b9d581a7374e786a76b"
    sha256 cellar: :any_skip_relocation, ventura:       "80c1850c505ef210cb4aecd823edb6451ad82c8981efd0974636043b9af39a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9296c3550e836311303e86ca4d14320d88e07a2777f8d8e2c367cfd82bd9ae"
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