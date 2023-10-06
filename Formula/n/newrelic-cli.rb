class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.3.tar.gz"
  sha256 "2b8cfe9279b54b6a84cb935594b00a3a3a3b36dde5bce220d1f8ba368f558201"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec42becaad4520c5409a0c4a91a5ff3bc2023621f5e05fb70c7819db0ffab074"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "922e9eac3fdb6f56224369791ea0437323fb07f3a0d7e17da5c66117163a22c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7bed80e7a95c6245e8d78f551c79ab7db2e41c7a6ed63f69f3857b29d4d840d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f00e6c81af3153f679275160d11ee68d064a46a1ce2807b226db98598fc09b3a"
    sha256 cellar: :any_skip_relocation, ventura:        "96c7ecb66fe70f1b28f746d4a8d33ea09341d7891428493baaaff05ccee6cbf9"
    sha256 cellar: :any_skip_relocation, monterey:       "91bc22b8309914b90b802ab157fdc31930bc492ccf2e5f0c2a5e1759c684f8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf4ab135ea3b8ab9d9066f82585a1943d1eadbca3302b585aa59c22aacc5a1d"
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