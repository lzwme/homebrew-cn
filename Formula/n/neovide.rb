class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https:github.comneovideneovide"
  url "https:github.comneovideneovidearchiverefstags0.13.0.tar.gz"
  sha256 "83256cbe4b14a8ca33f8ef5850121bad871af2f4fb3bcd81f6dae6cfc65c26d8"
  license "MIT"
  head "https:github.comneovideneovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5007392a3aed2daef6b4c4091ebad38c1ec1868889d7115827854200b0e0542c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f0d492ead1dcec682edc35d3d3b79da5d92d67047fdd0c8f2f8f64838743fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4dcf79d5118d79367ea4bf95a7303b277bdd648950218ba235cf3a9d037975a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5f4d5ed902f8b181a1d22c2b4188ffb6d50e06542a1b39b84496b1c004ef877"
    sha256 cellar: :any_skip_relocation, ventura:        "31cabedb237549cdace1c212bef87d98d68dc5bed04be62c3ea8d49b3923aa17"
    sha256 cellar: :any_skip_relocation, monterey:       "337a0233258fc3cc93e6f110345eb4b0281c7fcdd173d163ea147f2e1c102218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc41d875c6e54cdca4158019a47e095ae395410893e50a08c20c397c67c9f3c6"
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