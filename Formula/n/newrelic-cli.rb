class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.16.tar.gz"
  sha256 "4d92b22f8640fec5c07c514e8a1ca13c183cef8345458b9f8e1c471fb6635b76"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06f35707c0492045eb417cb2ea226eb39aa785cd0175cebf7631c621da6789e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb93da1713838bbc20f9c0d7a29b6cff22ddd50ff5ba8100d009f094012abb46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe199f806e16a1c2c806c84d99f76ee8c3e7cb17594a9611d22968f2f2083270"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14a82bffbb916793bc2964d9faeb987da9c6317cfdc1188acab5709e9d2fc40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b7a7830861ff6c2c9aa58539dec3b25e5cfede99fdce7a1af621534bfb6694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab8aa4626790209f663b285d6edf9b242a32d0f4b5533938de193a10f6c3786"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end