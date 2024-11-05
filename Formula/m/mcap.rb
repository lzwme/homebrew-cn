class Mcap < Formula
  desc "Serialization-agnostic container file format for pubsub messages"
  homepage "https:mcap.dev"
  url "https:github.comfoxglovemcaparchiverefstagsreleasesmcap-cliv0.0.49.tar.gz"
  sha256 "89c055c48cbe6010a95d950bbe657338da0455ce6da373f22469097028f927d0"
  license "MIT"
  head "https:github.comfoxglovemcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasesmcap-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df49c7a4a68007fbbba77b92a56119d14aa03052c660acb352655acea01f664c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe211d51faa2e5400b9b109ad55bdaf37020cb2767f594c0954d577fe1b91c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f18b8aca2ad7a4b9cdb9b9f06c7a95b9354ec20b8164b1a4a1d0e08f922064a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4427ca51a926194f019eaebb466437c3745b915d70350c919cc3f2faaea29400"
    sha256 cellar: :any_skip_relocation, ventura:       "d4aca89571330485bacecc39e5ec5245efd5160e04706c433f9ad944e570c41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bc66cb95122e993a66da9c4606cddcc8a1f7d041bb2d286abd177a89378edaf"
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