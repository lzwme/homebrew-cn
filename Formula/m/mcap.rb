class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghfast.top/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.1.0.tar.gz"
  sha256 "f5c8debb20a68d136018b1bc7c0a5250fd647440134ed50dd1fc31ec30f43d4b"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17e512520cb338d53df64ec487b0d79f4e9e5a65fb333a5257da8f81d3cf0834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecdff917b0ede83b2602f050dfeaaef15e7537dacb75905cbba7d01b4471d9a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa47270bae11a434733e6927abf925f5090bc801b025cbc6767df33cd6d3c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "600300856d1c6ff812793867df158edd9b24da33ee96cebf19b2d33dd9f7678a"
    sha256 cellar: :any,                 arm64_linux:   "04ee777db81aa7dc232b7c5d59c1f8c5ff7a899691d68ec0eda3a98fe97885d2"
    sha256 cellar: :any,                 x86_64_linux:  "932f961555176fbb3049103338138e0fbf114a7b03ced6b379541e2aa2027677"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/cli")
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

    assert_match(%r{^mcap #{version} \([^)]+\) mcap-rust/}, shell_output("#{bin}/mcap --version").strip)

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