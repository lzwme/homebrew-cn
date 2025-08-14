class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.9.tar.gz"
  sha256 "d56dcb34b0843cf9661bf6c4d5966a0d4872bb02211b4c122efd48f3eb6dea88"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d154a5f56ea29b19476738d0c44d9861f65f4bacc73567e49ce5701b986923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f526e160649378a5a8df1e7e78848e9a49903a32d8c0208040b9b599de346884"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cfffb9ea08b56d44af3b9be7ab384c7e63f329f32f917aa775e0f949f91ef0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3f62d48235ac0d61b7c3e11bc8e0633fd77f519ffffe81d4ff2ce7ae79b08b8"
    sha256 cellar: :any_skip_relocation, ventura:       "f4b30af421b7601870bb3c696e4d90cca5076791eee554dd77e94d738b4818e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d74f6d3c331923510e4bf6431a1bf128b979efd7bf36ca8996df6d075b43d840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c179f5a18c77ca3a02eb4d51d7c754442ebf23841e8095b1d161cf09f50fc472"
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