class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://ghproxy.com/https://github.com/neovide/neovide/archive/tags/0.11.0.tar.gz"
  sha256 "9052c11dedbf6197e9769724402f458dfe27463cd26e3a09ae5bb37f938dd813"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8a2ef0a90273d25020735d32a2de0ca9c7dcf72491815d7c943b91660bf8ad8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fccbaf3449290bd093a9901fe5b3eec8a0c4b5802524fef1d76bd6830296f2a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abcfa4a978e1218e436b8b9354c611e774c068913ed52694af3ba0c75d74509"
    sha256 cellar: :any_skip_relocation, ventura:        "95cbf0c9837c6cee7f81c62667e6204d6826ce24312b8fd45b7438a8a67c426c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4178487b71db439e679d90369da6ad465e2f30ef945dee324e1d7d6f455ef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "42c60269c011dd9428d7590e81d948ead638240ad4f7c2e66ca95ac0accff31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13099285a2ad9c785822d1a014975fc69bb1befaea1e1ec092fa463e295a732c"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # https://github.com/burtonageo/cargo-bundle/issues/118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "target/release/bundle/osx/Neovide.app"
    bin.write_exec_script prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neovide --version")

    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin/"neovide", "--nofork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end