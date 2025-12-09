class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghfast.top/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.58.tar.gz"
  sha256 "5207f5f52faec7db686e714c76d6edb2591eee705b517a7cf6fbc538b9013003"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bfab2c4959e8d34002a8775a4ea521f9fad103f8dde987f7f27d9fa9130c79a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b63d86e94cb9e62a816d649b36c61f6ea40147407c2a4452c45f08f01778d4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bf789ffb81339407e7dec6e01ab09ddd141f543d5c836eb9e7e4bee48546c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e7926bc9ff6f93ddd586f0f98d927f5b06dbd126890a4ada3dc63bae575f2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b516132136b54bd82dae5fd8f41beee5f1677124ee34def7b52cba1c1d2101a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13492d5e8570a8205fe59c7a0753987653302258d70d12c6a5f1d1330f6355c9"
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