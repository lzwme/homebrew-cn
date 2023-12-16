class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.28.tar.gz"
  sha256 "d4808013f369f9d09de4c5706a3d72222143a5e321c318be23b85ff9fe2c3b04"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad2b686a459c571ef62d6008d4ccab337c1cf619475364e21fe931571a175a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ee9d9ff3aafa1790d571bc02c414e6773acaa9f6ce54066bfc2aa21b3c56cbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "070ae74b802c777488f390776e5b9290b1dad0447c645fae995a2a3e0fbc3f90"
    sha256 cellar: :any_skip_relocation, sonoma:         "972b27caa9e601d0381082a050f94c9696b5c57625a2013740adcf4d8ab181c5"
    sha256 cellar: :any_skip_relocation, ventura:        "1013343dd03dfeda7033e9c2195f25bf5d17212255e463a04ca4ee67a0c31a53"
    sha256 cellar: :any_skip_relocation, monterey:       "62cd7f7a4fd14ba55998c2e39ba9c19ad5a004ecd7724b3f0f13558ca743c8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f332f88e3a1bc370848aaf74850e00d9055012117ad8ff218bc82d86696cd8c1"
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