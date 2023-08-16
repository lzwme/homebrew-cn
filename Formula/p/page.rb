class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://ghproxy.com/https://github.com/I60R/page/archive/v4.6.3.tar.gz"
  sha256 "51cf01933180499b27027fcdbda067f0cf80cebaa06d62400b655419f1806d46"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "115a1bee4a08a2e829bd9474e5896cc5f9ac415a509b29b26675bb14206465dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dff421473d67b5b753c57deb9221fbdc863ba341e72b41b1a90ce71286ced4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e41089194d5a0afbe9b9e7f0876ff9a30261ddcc983c2b8cc708e917cd5a0f3"
    sha256 cellar: :any_skip_relocation, ventura:        "9711f49884c59be816fa97363993b08b6f1655b1a4ec8de8a89c6e95355976b9"
    sha256 cellar: :any_skip_relocation, monterey:       "ad312adf9e277f5dede93292f1cfb5001c4ad3a26ac55f877e25690d3c386f15"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9598c8b80efa0b238478f877b19be504a1b07d3b41c8932e227a6ea4505cda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9cac68f8653a7f517a1cbe7429e98743e94379bf96564c11e6b81c964cb279d"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  conflicts_with "tcl-tk", because: "both install `page` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    asset_dir = Dir["target/release/build/page-*/out/assets"].first
    bash_completion.install "#{asset_dir}/page.bash" => "page"
    zsh_completion.install "#{asset_dir}/_page"
    fish_completion.install "#{asset_dir}/page.fish"
  end

  test do
    # Disable this part of the test on Linux because display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    text = "test"
    assert_equal text, pipe_output("#{bin}/page -O 1", text)
  end
end