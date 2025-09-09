class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.1.tar.gz"
  sha256 "9a4f01d67e633bcacb021ea1c3e7eea46cb8efcc42295732acbc1eeb56a00efa"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b25396f557abcee0d667646d09fc70162da137601f16e3a532dfdb9a7745c00a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56bef7bd1421cf36508b5fe45d802ece5f329cc06178b2ea77c38b68ff13fa40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db19523171b8acacf0393effa5eef8453e7ca7cef5a4e44ad8383386b3d8663b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9acc98ab48ad680a34433ba5dc58ac2454a1b8425eca97304c277b474db1db"
    sha256 cellar: :any_skip_relocation, ventura:       "de7ac25b6e39e10eb15238822c9872d9be2841efd6879067c66ae3436d754e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3e8a5f1c57fe782545085deaf0bf1c61854e63ce292b4aa7a9a53e99f9533c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06190106216d4cc48e189c04c05cbbc30cbf022009b534400e57718a62242e96"
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