class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.3.6.tar.gz"
  sha256 "f17762edb8d1c38745a25282bcf84f401101058ac1e8de92ada2c17d6e114a33"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94be3283bd86582003ccb6377528c4a733259ed32480b84191f43d8587132beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42b79c460c5c30d176aceb7abde7475f1ccb6c22db4cd76f6e96af0d1d381b4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7dfd640eb1041e03454914fc1d2d8e35490be7c9f740da52071292d3bcb8989"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3cc378a03dc82315fc6e4e7c5133a39c7e44fb0e72abd0c25beb29ff69a9572"
    sha256 cellar: :any_skip_relocation, ventura:       "52f964224c69fddab756e402abd98de298fca7d035fc8795a615dc02214a2a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44a569e17875f2a29e8ac99f65e7ad29cab71db8116b9f651fce8b8add624d78"
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