class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https:zellij.dev"
  url "https:github.comzellij-orgzellijarchiverefstagsv0.42.0.tar.gz"
  sha256 "35f620f8aca7128047e8be520c88514156c8249763cfbc103107499dd2052f2a"
  license "MIT"
  head "https:github.comzellij-orgzellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598327a8811c49b3c773e41f202b1834e2d2f5ee0acc37e46228b12f8863bd67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6d30dcacac2661167968fc57fe33dc1a335e5bc5fa5676f07bda7634d2cd23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11fca0c44d71ea493d68b2d0e3f26f536efb47d17872be143ea2591e44f92ae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "67ebf6119554db5ebaa09e6eeae32250fc141d5da24805ca5a9532f2365c7252"
    sha256 cellar: :any_skip_relocation, ventura:       "3674491bbed6a7f905fd236e3b029732ffd84d2933606d77083a21f3295eb009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ea73c50b0c0ae2d1d1968096606ed6ea2b6c295983f7c4f3d273bb4c3f1a2d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}zellij --version"))
  end
end