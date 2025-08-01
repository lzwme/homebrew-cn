class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghfast.top/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.54.tar.gz"
  sha256 "01da5b5a323a2f3b37559f20fc00f21399a015fb7a051f5087e9f463ca371b1c"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0aa59c422517d51120f08f5af3a03c2fd3b54576b8f0a1b043e8ae2014fef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ccb4b7485b0473497c5dc27d85fabed626738804b2edca014d167d3ef819dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd7277fc2fc0b530b6eab39b964b6b59b723577233829f12361fca46905a36be"
    sha256 cellar: :any_skip_relocation, sonoma:        "00297844cb37e1af5163b8102fa3cf6b2519dbf901e00459365249a60306929f"
    sha256 cellar: :any_skip_relocation, ventura:       "57a43171b7252a650ce026f925eaf1c0112c4ccd6ccc16b31e8ba6dc7e6526b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a50c26d8c8bb1e79c2fc87153721f294f6ddda4c4218117ca58801880b3a4a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64c17cb825f71354d2f7e91c5502736804235ef9edef89da093a240c0e9c9837"
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