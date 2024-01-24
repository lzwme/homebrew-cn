class Mcap < Formula
  desc "Serialization-agnostic container file format for pubsub messages"
  homepage "https:mcap.dev"
  url "https:github.comfoxglovemcaparchiverefstagsreleasesmcap-cliv0.0.39.tar.gz"
  sha256 "344effd2fa8e765eeff36539c635bc34aa4d31ad81ab4dbab376f34318aace47"
  license "MIT"
  head "https:github.comfoxglovemcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasesmcap-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "617f7fa049960d977030468b63f87938fbc39a4fd0972bbd6e8c1a278199e917"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4eb29bcd25a269554020d9e3001259f67a0840166715a3d3fa680c60f6642c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900617c680195bd96e3f0d0fec4707e7e5658024eda88b8ead32700440807063"
    sha256 cellar: :any_skip_relocation, sonoma:         "22c018bfa8fb7fd5397c17892fc31ce4f647eab81efbe7bef904503b51b91fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "bfe9f8f5a2e6e991d361daf36f6e712b48001c1160d1223c491ec346783be831"
    sha256 cellar: :any_skip_relocation, monterey:       "4c97bd70c5de5866dec1afb82c1d4253db8fb6fd337d08d50a2eaa45df3fa1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cb2f8eae8d4b1ebcc4339dedb16d09af3fd38c29f205a3ef0d824f1348e3415"
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