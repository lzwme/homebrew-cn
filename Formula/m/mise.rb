class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.22.tar.gz"
  sha256 "5f24476f1f16fca78f5a0aa0de705f9d3b273c743148b5fdd6a94eeb1687636d"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb5a08b9ac5c5653949d2032c3a13c4d6507cee78c3d21b28bd8bac9d6a9bec3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "904d37593f1fde60b21b7da1e75953ba9e80aafef78794370a80fc0109aa1720"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8525d595fa5a421e064e274cb85ab70cfd9a1e68670d1e9b91a3339bf9227e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "3337efd6796c1ce3e1181663c65a9470a27f9d24ad5249833e62537bd90d88be"
    sha256 cellar: :any_skip_relocation, ventura:        "038385ab84c76a6bb91e295fb14c456be889e85d3401cdd6fa8acbb3a3a0c201"
    sha256 cellar: :any_skip_relocation, monterey:       "2bbd2177ff863a30146210b68820f9f2bf832c4346336fdb220e9e66f1f8770e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270eb1b4609fb77d653994cbe7c435e7fd9dcba6be5edd92172a1f37cac97ddf"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}mise exec nodejs@18.13.0 -- node -v")
  end
end