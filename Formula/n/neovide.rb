class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://ghproxy.com/https://github.com/neovide/neovide/archive/refs/tags/0.11.2.tar.gz"
  sha256 "62e973a5407a6bfc731ce78e0495d2ed10930d33b22fe94cfe23acccbf789ae9"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5097c668b6eb5b69928802c67b1d714863e0a63da6929d536d2d5ab8dcde59f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "071648803ff3b7cc821ebe4224ca1d98daa574ad23c231dd8b27ec11f8d7558c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ddd95e399400a6bfbb85d3cc3d9facea9548badb09efb51f83604559babc31"
    sha256 cellar: :any_skip_relocation, sonoma:         "277e241ba44ec0375f9d30c5d2a04c2f31c5cbe20c5cb882e8c97859859f547a"
    sha256 cellar: :any_skip_relocation, ventura:        "19c48c32be2aa01670b56315ea14c26ecbfd01ac4ffe36bd364c7a3460c286d5"
    sha256 cellar: :any_skip_relocation, monterey:       "01981ad0f511fcdab3c144ad50dea4b61f05642c4df08e93eae6dfd7f09e2488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5daa39fcd1c3a4746aa67cbbc2c0660aae2f0dcd2c544b498a52d6dfccd291"
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