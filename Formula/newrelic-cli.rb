class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.65.5.tar.gz"
  sha256 "97d355831d4e2c1be3bc465a9c671f1328841df42a567bedaebdbdf4958702de"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b58c2a6a50f28e79e684670434a9e77de76672059ec375a404eeedc0dd1d664a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cc8d03a0d1517071d5e1e5b32de384e78cb12936748a7ba32dc15c71657ff30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3b6c47b37c8378b5fe0428a07efd68441a5471418349f28980fcd3ea6bc58b"
    sha256 cellar: :any_skip_relocation, ventura:        "ec263ec226e47ac10c2d128814c9d0822f90f18e612670d6356be1f00a811d75"
    sha256 cellar: :any_skip_relocation, monterey:       "37af10ec0fdc9e7410aa508aa0f3f8bdac32a0c181309655d6a6e9c18f7421f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f35ed05c5081398f0c1bb9c07155b9e16613a60cb508ce5c4acd8e4e6022416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ea5789499de1770c93139781b4ecd7127ff2eaf3b3ac307e8ec2d44146647a"
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