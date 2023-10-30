class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://ghproxy.com/https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.40.tar.gz"
  sha256 "f9d26bf5b1a811752d82764b4824940e7273cf411d736f8127de43af774d4324"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d842a1fa48c52a0c216e6ffc2b65f640051af0a793488cadb51571d31cba12cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d842a1fa48c52a0c216e6ffc2b65f640051af0a793488cadb51571d31cba12cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d842a1fa48c52a0c216e6ffc2b65f640051af0a793488cadb51571d31cba12cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "b801c9740d7272d96b17c6ebc785aa7c35729efbb2286e87ca5fb73bebde1c87"
    sha256 cellar: :any_skip_relocation, ventura:        "b801c9740d7272d96b17c6ebc785aa7c35729efbb2286e87ca5fb73bebde1c87"
    sha256 cellar: :any_skip_relocation, monterey:       "b801c9740d7272d96b17c6ebc785aa7c35729efbb2286e87ca5fb73bebde1c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f682206fec8f79a450039532998a53fcb55f10b478d09649c1d61de070b93b3f"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end