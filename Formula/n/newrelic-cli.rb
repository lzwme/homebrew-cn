class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.0.tar.gz"
  sha256 "268ccbb349b0aec2523116241d49fb993589552afbc5f93e677739e7cf1ea4c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6b0de49ecc4afa730abaa9112cd20f3575070655610088def5f49be1442f6c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c67853e30d5da4764bd59c5736af47c9273497a87a37fe108e47774b2dcafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e003f860b808a82a0fb2805c20847f1bc23465ef86697c960b4353fdec13a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "82b9a86d765137026eea44be8a73e158a209f83fc95a69cee077bf8a2793976a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f71e37a8f3b2c166fefa87b3611ddc1cf6e1697766a51680b78aa23d7ae406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f219c9efc3efc3b0c67d6525e624f6656a688f013df565e036d1d2c746cc0d1"
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