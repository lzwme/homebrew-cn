class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghfast.top/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.59.tar.gz"
  sha256 "502f32d923ecd22dd2fd4aa74b90392ec2c5e090d2b7453f1c563e7c16a683e8"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f8e65c9663b0f6abb0d27cd14f73eb9ab7ec0a8f231ae2fbb44e5aff55f8228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61703a06b59b2a438c76f8a82160aae3e6c90df97c104b6e7314d6df4c4826c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263d8675d5a386e90d8e3250d18b846a5c841b31ecba1ca00c611d3f3ebe5658"
    sha256 cellar: :any_skip_relocation, sonoma:        "678c03962b0bfcd0be865fab5774eb3f73b1fa4c61925be73607822493617acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af298c9a99bb24e3b7923b87f53563a99aadf84a9ba1a5edb887b886cbf483e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd398865e17ef8a407a2b9b1620abfc77af973832a18c42f00d6c04f67c0434"
  end

  depends_on "go" => :build

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", shell_parameter_format: :cobra)
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