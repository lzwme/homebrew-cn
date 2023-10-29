class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://ghproxy.com/https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.39.tar.gz"
  sha256 "1cef76643592b2de2df72885f144d2295e322720e7c268366fc99ca7aae82061"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5733efeac0cfd823e4e6b4c31093459b0940df15b2415186c44695a0a0cd05c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5733efeac0cfd823e4e6b4c31093459b0940df15b2415186c44695a0a0cd05c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5733efeac0cfd823e4e6b4c31093459b0940df15b2415186c44695a0a0cd05c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f5f6f5b32b23af21e720b6083bfcc127a56b65e48f8466224593026b94be17f"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5f6f5b32b23af21e720b6083bfcc127a56b65e48f8466224593026b94be17f"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5f6f5b32b23af21e720b6083bfcc127a56b65e48f8466224593026b94be17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac01ba4497cc106969a23626ecfc6130dbafd848a0ea94f11ec24ecc81c5e1d2"
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