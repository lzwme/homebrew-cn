class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.22.0.tar.gz"
  sha256 "ccbdfba6af89644f8e0e900278d56505806cad1c9cad0313044ee00b4c898bbf"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d4ba6bfb4dc5547857dd05548fc5567cce2067bfd727e1152e9d304866ec4b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ff81bb387f847fde0a51a923c73c025583d896e814605f82f169229b07d76eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9b2c157ce29b599280b38bb5e736f49dc4f6ab498457b80cdaa0d545874a652"
    sha256 cellar: :any_skip_relocation, sonoma:         "fee3201c321dc598f48556b1a7e3bc49cfdd9b3c5a350db2046064033793fd3b"
    sha256 cellar: :any_skip_relocation, ventura:        "ad3f29b7a276e4869d97e21c7efaf3d9fd729ea84f49a5a28efcc81b26e05a3b"
    sha256 cellar: :any_skip_relocation, monterey:       "b0ee3f4a638696c754f47d809ba3a6dae7233eb0a635a9ff8f31738df2a35bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b512941c50989b3bef7faa1a4b3970a8cbdf69fd8b3b138b3270deaa6d12541c"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end