class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghproxy.com/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.37.tar.gz"
  sha256 "e8e04a428dc4b679d5f019856a9d6171adc27f174dd1ebcfbacf642592185741"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d16db033f5bf74c7ee83232cf2421909455ac4b887edb0270ef43fe3ca58d8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fc950f6df487cd10efdc5349e7bae76a890db8acf435171e3fb7cbfd327d7c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69c6fca63f3c26bdc57d3a389405a609b3fbec50aeeb638bac10588b10555320"
    sha256 cellar: :any_skip_relocation, sonoma:         "073a7e89c24554890b5bd84547e49d513f4df09e3d3c7c2159b3c4b8841edeba"
    sha256 cellar: :any_skip_relocation, ventura:        "8cdabe47816c2a2c8ac123b83a478862db98e4f6c8f5e5a21d2100983c1408fc"
    sha256 cellar: :any_skip_relocation, monterey:       "b0008dd33f22dbc30ef7977d0d5f65b2fd1f28d6c3ba555f2b14a2186998688a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b04d188bd8e6ae92c8c6481062fb886049df5ff2801dd1d71e19914c34ef675b"
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