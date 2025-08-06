class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.5.tar.gz"
  sha256 "3427f95b1dbe05e2ae49f06b5870d2b41edf2e3e1c4fcca9b1071214213b934a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5b9422ade200ce45c0f6c6a0f4db3db3ab7a598f30a7e1477b910957aad2cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ff1ccfc6708698585267a2e93b3641a29474eee52f72d2d5793b0d447536e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65fe2d3de1bf2877b0a50399b89a2922dacf00a6fb1c26b9ddbcb6d7b6d80861"
    sha256 cellar: :any_skip_relocation, sonoma:        "d637ae1fb017270539a6dae4eed36eee417769c5f59464b421af946053467e41"
    sha256 cellar: :any_skip_relocation, ventura:       "df5dd4c7cf3b76e57815e5175dbece19b00a405061b7c394be3add9b1b8bdbf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd36afe6167a0ea6b735d9d9094098e88b92755cb56eb34da6307235860030e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6004f44f789f285ece4f378361e34642425c4da42fc48a1d3ea2c7fb00936e3b"
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