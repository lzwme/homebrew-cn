class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghproxy.com/https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.33.tar.gz"
  sha256 "bc3be0f2a193f24f8949b2bd35b4f8a0544ea1aa0be56b7967bf7db3133d2b4e"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "479e5e126c1e0b12564a4b95a342b22966328f013cf8776d28e73d2fa2a184e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0c0c8f2e41bde7ca62c1c6b59433432fe5159a9f04535c57dd04a2f328a8bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cec066d20ea27436b1ff9cfc76e64843a65b380f7166ab23448fcf0397bd685f"
    sha256 cellar: :any_skip_relocation, ventura:        "619cb2fd22c3c60ab4505c784fe0d37a1d4ed2914add9b837f83c02aa5bab21f"
    sha256 cellar: :any_skip_relocation, monterey:       "38f2e32dff62a3fa13b92e1e458bd409244bdf598656e2a1868f853a177bef47"
    sha256 cellar: :any_skip_relocation, big_sur:        "61e059a50bd73c9fd8bd611b0e1f441db67d4030780cf3d92406c5c5b60f3cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1075a26666cc05caddf33568ff2a49e29d19461148887af1425f0511ce657c"
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