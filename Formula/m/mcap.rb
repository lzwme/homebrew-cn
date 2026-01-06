class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://ghfast.top/https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.60.tar.gz"
  sha256 "a4cbd23b9e06a66c6c950c5a82a1daed67948d537772f1c71969adad2a23e3a0"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e05404215c72bdf6a3de94037e114fde0e8b60e205a4c300befc96858661fabf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f354566fd99f64360dc00bd00238a2b7861d3d566a82ae7bf5243809bb6df19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc62402a621873f06ee30645fe3cbb4f596aefef10c8f469015199aea91eb17"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0df1579922f99fdaab5e507002ad0d48294e5efb0e473e221195b6c64ca6c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463471d62380fef65198a9ac4b5bc5dfcaef4fdfa54e797be3877a287d02f660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f27376ab38f4bdc5376790282e1ce12e34c30d34d3489c9c3b3264bb8b568073"
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