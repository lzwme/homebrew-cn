class Mcap < Formula
  desc "Serialization-agnostic container file format for pubsub messages"
  homepage "https:mcap.dev"
  url "https:github.comfoxglovemcaparchiverefstagsreleasesmcap-cliv0.0.50.tar.gz"
  sha256 "f124fbcc4adddd7b9aa74ac01ffb2c5fc00b72db1c98cfd988d67fcbd1f965f3"
  license "MIT"
  head "https:github.comfoxglovemcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasesmcap-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff98690eefab49bac58c6bee59a1579d113d889dcc5a7f6bca4e4c61e8da08d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "518542adac647d8daa0a297d1eb65d2892cc04693b7709ee5025403470ceb25c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5afc4ba8ba84f8deda8bdae5f51fc3684676d436c7abcfb0992f9c18736efda4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e996b4ddef4812b1fb77564411582faa1a9e9603a08b401a9fee95a380a7d6ba"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2a374f9b4969e58d82441b6b73b3359e93ce30f9bd642f9a797133b93f89bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f965fb8982ab070aee33b9e1c46d64670415cab488fcca027a3df17a62080162"
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