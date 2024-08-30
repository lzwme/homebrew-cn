class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.35.0.tar.gz"
  sha256 "f1ce3fe46c57cba0096227f8c9251d3b476e54e8a620eb39707d0ab3e16b8f55"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "454b9f0f223c45eb885800a2d22aa521bdf777ecbfc76c2df7a85e84814740b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1872406c7b89b11767883e22808a50fa0fc731cd6113a0e4597165987f1ef41d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dddd0bc46851928a3b130259a2fec8fab8032f577aad6d2cdfd1ea1777d7017b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fc6933dc4e9d0383a714da937ffef5e8841d1b7be982b2e372409f819fc22ee"
    sha256 cellar: :any_skip_relocation, ventura:        "2ae0a96dd93fb7471fac74f396b5a0168779c34d6badbeb7733e6d5144e51786"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1e1e0f32afa1dd554bd407420d5236af2812f757e9de6d3c89fceb5521652a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9049d74f853c32933739b7b0da4ad25e64581f59c74848949ef454ab4b81e0af"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"just", "--completions")
    (man1"just.1").write Utils.safe_popen_read(bin"just", "--man")
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}just --version")
  end
end