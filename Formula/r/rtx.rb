class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.30.tar.gz"
  sha256 "c4e07cf0762cf91a547fccf7c39e4f939a96675a8d926e10029ec9026197c72d"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9937d153adf33e840f303c5ec9869ee58bd8084dd118284054e852afd13956aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "631110cd15c196a137db2981a418d8e770183dbadf179e39b71a6586cbae5d5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8baed7c501efe928f03ce7e47f0ab75f146b628b61e80bcbb31924703ca266c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c87f247af96559bb1d4f24618561f2725f5cbd7b6c8626258891fcd7bf8cf58e"
    sha256 cellar: :any_skip_relocation, ventura:        "8b44310d28587d30da335bfc2427ecc8d2de98b4916c703d0d579d56b3ec1c19"
    sha256 cellar: :any_skip_relocation, monterey:       "df7b4689b249a4ed743bdd0cfe7499edca439f53856fbf19cf2e14f5b25532d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6caa8d0fe64481ad59e3455c6e39b29d8ed5001f4d2e0fb4226ecc2085b64de"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{bin}/rtx activate fish | source
      end
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end