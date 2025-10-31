class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.1.tar.gz"
  sha256 "4095853203801e34118e7ac676575ae870da5b538c4dc4779e9aa95ead31748f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6c5268ec8929fe8b07010315260d69afc113baf980363bc5567f1106ab72e0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6457530b2c1f31545b064790a3cfb566d8741f9c457e23be0e7cd3e232846493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90d28959e27ba9c7256b763501965010f05a9c9d1ab728e2477561825999e6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a4b493411d92a77b6bddaf9f46d02001ff62a656118d8648f2b7695e8c8f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1fa34a44b8ded4193b4ee2d7a62b17da9d0d40c66b1542f117674c3d57f455b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613e422f45ab2ce0d9cdb13ed3a571f441ba5f1edbb9d9d0bc04d37a3c9bd1c2"
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