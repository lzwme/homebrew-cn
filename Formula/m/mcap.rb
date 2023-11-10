class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghproxy.com/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.38.tar.gz"
  sha256 "06e8c3d4eb0f7a1cc2128a54025ba9bd62366f4f0eceef5b23e2e5d727873425"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d1c21deda5db8c3a89ab8a9c38c664cc2e2038170f3c1ffae856e96f0dec062"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb17dcb84d2f945213c6dd9319fe90940114f8d8c2dbe1a343ffaa6907af0e84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e719b6c85aa4911157bdd8cdf55dd83a327cba1e058050d4bb942538b288d726"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff69eb6dacd09d53955e18011588a9e21c7b65f5a91db0210ec16030ac044cf8"
    sha256 cellar: :any_skip_relocation, ventura:        "95be2d792afeb457af25f5c1d92eba5d257ba5b569df40177bcf6f60fd57f192"
    sha256 cellar: :any_skip_relocation, monterey:       "e69bd03d3c48f61196e85a3172164c2e1d7e6ac3cb0e444efade0b95293f5fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e45b9a38d90697995fbf6eb8213486916b18441fb2282d09838f74b752709a6f"
  end

  depends_on "go" => :build

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion")
  end

  test do
    resource "homebrew-testdata-OneMessage" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
      sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
    end

    resource "homebrew-testdata-OneAttachment" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
      sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
    end

    resource "homebrew-testdata-OneMetadata" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
      sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
    end

    assert_equal "v#{version}", shell_output("#{bin}/mcap version").strip

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}/mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}/mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end