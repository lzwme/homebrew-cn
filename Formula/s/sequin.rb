class Sequin < Formula
  desc "Human-readable ANSI sequences"
  homepage "https:github.comcharmbraceletsequin"
  url "https:github.comcharmbraceletsequinarchiverefstagsv0.2.0.tar.gz"
  sha256 "f78cc05bd476ec8e928ab0fda62f9475d63d3c1a9a6c0d229d8eae80202e3fe0"
  license "MIT"
  head "https:github.comcharmbraceletsequin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "809be5b62e9e1c4afa7387c7eef4ecc59076a7638a7e5025fcf2debdcb2242d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809be5b62e9e1c4afa7387c7eef4ecc59076a7638a7e5025fcf2debdcb2242d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "809be5b62e9e1c4afa7387c7eef4ecc59076a7638a7e5025fcf2debdcb2242d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a7d172d0a73886457f1de58e443f15beb3e291eec974caef85d241d1cf70cf"
    sha256 cellar: :any_skip_relocation, ventura:       "60a7d172d0a73886457f1de58e443f15beb3e291eec974caef85d241d1cf70cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f9789f45c52ffc2b2c4890cc244d2da0c997aa71bce8f6c7632f621aab77e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sequin -v")

    assert_match "CSI m: Reset style", pipe_output(bin"sequin", "\x1b[m")
  end
end