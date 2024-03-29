class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https:github.comtldr-pagestlrc"
  url "https:github.comtldr-pagestlrcarchiverefstagsv1.9.1.tar.gz"
  sha256 "73c8e48f2c2e2689c47b1ef32406267e0557561996517773ad1d99a3b05435f3"
  license "MIT"
  head "https:github.comtldr-pagestlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb557d91774f7b0384bdcc7f354eafa5b8b5371f0234e4a90c466ddea01dd6f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3d31387750b87d73c0f79ad5c97014ced01efef1ffedb55e84a751e15425321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3fce31d2900e4eb2d522dae7925fd517fb80452bda38af9ba51ba05cada3b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "02047ff55ab1579734f60e035ef95bca13f92da9950edc7b894401dab81cc0fd"
    sha256 cellar: :any_skip_relocation, ventura:        "7206b200f5d6151cf6710443d37dc726711fe2132b881429caa0cf0e39c743fe"
    sha256 cellar: :any_skip_relocation, monterey:       "dc8473550cca6553595f3b689c394f1c1c35e95f1a7267bcde1ec756fae0ff79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0bbb84f2871477f94b6e6157ac7f9cf719f807b82e561989be14744b3fc733"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "completionstldr.bash" => "tldr"
    zsh_completion.install "completions_tldr"
    fish_completion.install "completionstldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}tldr brew")
  end
end