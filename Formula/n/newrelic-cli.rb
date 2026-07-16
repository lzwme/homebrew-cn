class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.18.tar.gz"
  sha256 "ab8044ec540706149505201ae05beabaf49866763bf728ffe747e5cda2051322"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35451fc924c63d43b28654dccb01ed78f8b6cf18559a691dab7db75430a32818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7fb83a0495137e8dd947e230bf8c64128f62f8e0163df7b438e48bc27c089b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77ef734ad4e4594cc6216b09d29b0bf51c2b65f80ac27c71f5772e37d864d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f697d2501008a94ae8a8a30039a7808a18b7fcfbec51cef8f19817b06c5c7a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e94045407a44d0e47025ca260262907c451d5af805a6c130f30c52e9c22bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "245dcb73b95f03581801274c1cc240ebd9f76209449d9ddd32f5027c6f813c65"
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