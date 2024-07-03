class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https:github.comJake-Shadlexwin"
  url "https:github.comJake-Shadlexwinarchiverefstags0.6.2.tar.gz"
  sha256 "676a441fe9878c1a3efc4bb69a6bc20e8bedc4ff5eb0fab61d479611a4655729"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3588f0d86345843e659d555258f7b32b41a8196f3e97f9e916d6e1b97c68228"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca296ae6da5b2066694687872585c1cb3db8310b55a13c072ce5fa4f76ec11a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbe4f319a2b60df20869a1735af8ab82c6d40190c4dc87ecfde6d6857498b8c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a922587b26ee40b72165cf61e3668de77448fd74147ec3477a2607bb0547dd96"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5bbb4f26cbb2c2e5d2a6cdb261074af2552899ad9cb061d9eb4354d0dab6a9"
    sha256 cellar: :any_skip_relocation, monterey:       "3c518cf21d8eabfa089cdf278c415bbc26744066e4b1cc20480852c5bda4742c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f01c13a9391d097c8115eab4ba768c9e94106a050d02b2e87b78f48777faf9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath".xwin-cachesplat", :exist?
  end
end