class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.72.3.tar.gz"
  sha256 "91a831329260e431dc203849008fc6a96582c3d80cb8aad383aa3ced9242d752"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ab5f37e90563734a6e49fb38710638f2ae328eed4da75449c8863506a64cfaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6253f1701628ed07ce726f1a9b698387915dbdd64d5b9f82f5a1988dc4d14213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbfd652e3577d0a0238a5dc603306e871e002e57c6af99fdaa9c68a5b3de294b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e4bdb57a5974d5c6484436f49efe2c056d4fb9d4e0dd785313e1fc6dccb0322"
    sha256 cellar: :any_skip_relocation, ventura:        "6b8fae4e56f8335a41f1eb631d544343f44a38c113cc6dfb03f7a402ba7ab4be"
    sha256 cellar: :any_skip_relocation, monterey:       "84d47f2452a93030d14973a7c7d67242528a115a3d8811b0971ce521371f9348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e9a4680ba3f1f585ef47774987f12077177dd896bdee92f1ec236398b2838b"
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