class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https:github.comneovideneovide"
  url "https:github.comneovideneovidearchiverefstags0.13.2.tar.gz"
  sha256 "3ae09d94ad6bbae9fdba306523b28071508c5e8eb205bc8fa9f32e7323fffdb6"
  license "MIT"
  head "https:github.comneovideneovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c846b06c2ae7441b419c247265cd4847962a2115ec7a9a12dc6f912d76452fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71291af118ee6c1eb490c367e2383e4136c995ef8bf05d822e1f42a1b3c0d44d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01803e27f1e187fc23f5ab8291f526e3a141adb005b19e0acd13d0ddecf2078f"
    sha256 cellar: :any_skip_relocation, sonoma:         "11b5267882ec704ae099f429d8377f250da870d1b39940a5bc1b478fefb8902d"
    sha256 cellar: :any_skip_relocation, ventura:        "381a3de45b14561720a096e9a8f7170f5b260b2d29f5ae14884936a6523bf6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "4f1d2299d2523be0cc650cb65028f05e35a747e3f321fd8c9928d178aa25c5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b982cd5bdf3349691c1b80a671f1ce1914816835d55d9d77c7361649cf7bd0c8"
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