class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.5.0.tar.gz"
  sha256 "9713eed8806d96ccff20fdb2571a8669ab4ac2c2e26c1aac03741b1173085e7e"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21b7a55778ab0e8ca94aaba1efd07e374c946e91a9da6be8521ebe7241c9e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c505386de769df1ef58bc3ea686978126388f30310007eda50203b8ca68d6e78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "165f77e325d5112fa6ecaf4a8ce869ee6a313f90fd185a17e7b9fe8c3472e528"
    sha256 cellar: :any_skip_relocation, sonoma:        "25056dc88de49afe6d0a6abfd10f5918db9c869d0f8c5238c01363638bfd9dad"
    sha256 cellar: :any_skip_relocation, ventura:       "1bad662d81fa68b3551ba6852e0c90824528939bc4c4b84cb559813e25db24f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38495a227cb88dbab94549f2e2c45cccdc59769d56c468e16e680813e550fd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3bd16662525e94956f1a1d1b99df27d96c56bf80f9e3fbca2a4eb3e747580bf"
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