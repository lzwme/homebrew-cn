class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://ghproxy.com/https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.42.tar.gz"
  sha256 "89271c08845b992eb350f10332ec1ba76ba8d0135c75a6f353799dc018c64978"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ee093a478059269f3ae5876422051b4f5689563eb656f4cfa9d22823236580b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ee093a478059269f3ae5876422051b4f5689563eb656f4cfa9d22823236580b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee093a478059269f3ae5876422051b4f5689563eb656f4cfa9d22823236580b"
    sha256 cellar: :any_skip_relocation, sonoma:         "80aa8174b09566958d7266560c187c1dd25644c05be298531f432e45be279923"
    sha256 cellar: :any_skip_relocation, ventura:        "80aa8174b09566958d7266560c187c1dd25644c05be298531f432e45be279923"
    sha256 cellar: :any_skip_relocation, monterey:       "80aa8174b09566958d7266560c187c1dd25644c05be298531f432e45be279923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60422a9194264f99ed491f10fcfe72a71387e60b1d0feafb2da55b9a8b191782"
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