class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https:github.comneovideneovide"
  url "https:github.comneovideneovidearchiverefstags0.12.1.tar.gz"
  sha256 "95df61d51635a981697a6c4b3e63a9feb29bb90bfc69940c02c73273a61cfd10"
  license "MIT"
  head "https:github.comneovideneovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95dc2ed82b0470de29f98672c845c7940544c83d907878a17759781728299126"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4292987f8e2e7e4dd843882efaedae3fdb534df59f25cb6ca6a910a42ed5943"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645b87ed720b392dac866566b70b93680d9bc34e21d3d37d0f9bf498cd8c4189"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d6f6bc738f8d941d2e4b8f0b0a8239c66054bd16e341c5f7d00d2055f624b4c"
    sha256 cellar: :any_skip_relocation, ventura:        "71ac0dd3c68524415e10a01c7dae88a0111d9f1961f121e11402807d2bb67adc"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee4896a6b4b6bda5a893799eecdfb7a33a94ce96ec20d611049191131d54795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18dc83a5a6a6a21eaff93e6c83e00b73da269abcaee58791749b513dac4b5d49"
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

    # https:github.comburtonageocargo-bundleissues118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "targetreleasebundleosxNeovide.app"
    bin.write_exec_script prefix"Neovide.appContentsMacOSneovide"
  end

  test do
    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin"neovide", "--no-fork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end