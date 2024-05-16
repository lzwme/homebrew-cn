class Mcap < Formula
  desc "Serialization-agnostic container file format for pubsub messages"
  homepage "https:mcap.dev"
  url "https:github.comfoxglovemcaparchiverefstagsreleasesmcap-cliv0.0.45.tar.gz"
  sha256 "4bcc448aaed2728ca54226a030823a83c2218accdc9da1934bef797321cbbd86"
  license "MIT"
  head "https:github.comfoxglovemcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasesmcap-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41fa0a167b729737b4c23d4ca929f829ad024ea6ecd465f112607f0b5549a5c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc66e1c54049d1f30a33e8def139f1212ac3010bfc3d35fb2c346c6b8581e534"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99328578f85a375a152d26e42cdfb5a18dffe12d5ec4cc4ce456a92f6acb20bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "b69b122427019bb40f6641976b28d022d2c52396d92e941f3831ec87a15bf0b6"
    sha256 cellar: :any_skip_relocation, ventura:        "14c4ffc71cd83cc9b25e91aa79ae4d231eff4c3fed004da128a89cec8843aadf"
    sha256 cellar: :any_skip_relocation, monterey:       "c9118b0860cb71cc20d2dea287f5fb69f95782ed6625d229c66bab44ab814746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b745f0aa507c0f642b81ba3db83e02cb8cfe7fbda86fe6fca4968bd35769aab"
  end

  depends_on "go" => :build

  def install
    cd "goclimcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "binmcap"
    end
    generate_completions_from_executable(bin"mcap", "completion")
  end

  test do
    resource "homebrew-testdata-OneMessage" do
      url "https:github.comfoxglovemcaprawreleasesmcap-cliv0.0.20testsconformancedataOneMessageOneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
      sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
    end

    resource "homebrew-testdata-OneAttachment" do
      url "https:github.comfoxglovemcaprawreleasesmcap-cliv0.0.20testsconformancedataOneAttachmentOneAttachment-ax-pad-st-sum.mcap"
      sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
    end

    resource "homebrew-testdata-OneMetadata" do
      url "https:github.comfoxglovemcaprawreleasesmcap-cliv0.0.20testsconformancedataOneMetadataOneMetadata-mdx-pad-st-sum.mcap"
      sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
    end

    assert_equal "v#{version}", shell_output("#{bin}mcap version").strip

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end