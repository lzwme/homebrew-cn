class Mcap < Formula
  desc "Serialization-agnostic container file format for pubsub messages"
  homepage "https:mcap.dev"
  url "https:github.comfoxglovemcaparchiverefstagsreleasesmcap-cliv0.0.40.tar.gz"
  sha256 "6413972eeadb3b6555a1e6dc59f8cf88e3db2cf819ed5d11564b1f31fe3df2fb"
  license "MIT"
  head "https:github.comfoxglovemcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasesmcap-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "269531063a715d2f8a6ef821b0b571da4fe5f94b56503f150bf6e376b0cdaebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb159c13d86341531f7bf7a7f305e9b9ced8507e9c8650499f77fd0aed4266f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bfd5a35c34b637d03afafe3d9bcbc65da9cd829399d673db44434152b1c697d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a8f92a7314cca9cfebcd6065a21be47bb447f1ae954306fc65cd08bbe6f503f"
    sha256 cellar: :any_skip_relocation, ventura:        "69ecfb4ec6465b355222d8d20bac5a562847fee45e93ec0ce5064338034449c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8b54ec93b3a253dc98e862c7910a912627e9333ea71280d2c6e477b5280f1ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced425bd8a689c1175e33c30902f2839272161ef84c19ecc5d3013930b5a52cf"
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