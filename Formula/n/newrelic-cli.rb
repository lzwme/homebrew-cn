class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.1.tar.gz"
  sha256 "41afad63a9d3c5890ed740ac9e98339241ffd75fa915e85149aceb3a14eb8993"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a58403719cf68b8e8d1de4e44b4a8f2b5cbeec974623831591231673e210011"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6220caf266a34640aabb22a023f9bd01ce6f7b6c5ac514081dbfeb3f25eb9ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be84ad7ebae58690ebee2e1101b33fb239687a56e1edfce25ac6237e788333f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f90dace1edc272f697738f3b7aa9e4a29fc2b68cf24d9dcac40f1d0b1560720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "59110c7cc580e6fed1f6a8fe24485c278b879ed49835a369fc22fcc869729023"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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