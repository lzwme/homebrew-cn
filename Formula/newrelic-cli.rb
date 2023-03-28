class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.65.4.tar.gz"
  sha256 "f6c8466b4e3e6fa4bb257191880c3207735cb1169e300782a0c711de75250788"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1580b5a3325fe44814168a4daddac622343c62e4254bf8f220394eb8069a1748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c6a2ea73bee1b0af36ef15006a6bc334028fdfda8671c17a6edc6df3ffc815"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a425ecb32b30374942a08dfe80fe5491c32ae58ff89d7ee5b8cd1fc0b9026393"
    sha256 cellar: :any_skip_relocation, ventura:        "14b2522a514b102db77c03cd9eca96c2770bc4a3c4f16a28811368ce187bb45a"
    sha256 cellar: :any_skip_relocation, monterey:       "923138f96d9aa50aaa88283320cdf7951579393fc978503a4f28f64d35ea69ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6f567c54d9c1afa93b611c447e8d338cb5d178e27ebc6b9be28eec4f77bf4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "870f671751b087c9a7d52658ef7a713f618757182c4986914b106f88ce18c036"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end