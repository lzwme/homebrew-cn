class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://ghfast.top/https://github.com/structurizr/structurizr/archive/refs/tags/v2026.05.16.tar.gz"
  sha256 "c7230db428187fb0f1c55c33aa6ed09f686657c2bcd33fa51d75c637ec57da33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1d70dc361eabacf8d1506d061b78486351635a17a3318f010bdcaefdc40ab52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fdeb05f9a88f4632d10c0fd6de99b723b723daf020e819ad7b0c3e4c23134b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31f6a89475cb5be183c6e59face37ffaf977ed93840847c9781c5f8c14d1baee"
    sha256 cellar: :any_skip_relocation, sonoma:        "11267166a3ce0f85d61b5173585f27dabec4c8893df283e4c77aaab99c69991d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc3b90fe5efb3e7cfd95252cd6ebb1ea58e8a6688bf5653f38c6bc91a7f20c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d709022e71f322c820a2ba1dbe2110d9978fb26967671f6385c5df729ebab6b4"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dapp.revision=#{version}", "-Dmaven.test.skip=true", "package"
    libexec.install "structurizr-application/target/structurizr-#{version}.war"
    libexec.install "structurizr-mcp/target/structurizr-mcp-#{version}.war"
    bin.write_jar_script libexec/"structurizr-#{version}.war", "structurizr"
    bin.write_jar_script libexec/"structurizr-mcp-#{version}.war", "structurizr-mcp"
    # NOTE: excluding structurizr-themes due to unknown license for PNG files
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr: #{version}", shell_output("#{bin}/structurizr version")
  end
end