class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "8ab4dca62742d793b3f991463abeba99fc60ec8c2f4f875ad24d08648a39813d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "991598d945498653ba6b8818912e2a2228dfc67a206d25c6bfbcd4218fba2033"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af2b47858bc0aaabcee9a07f06fd22d9a93373b010b3c09dea9ca94358ab9a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d813ca1d3d8d51d1f007f0a4f046ae0edda8b9a5e26f7ef9e3e05eec8a53095"
    sha256 cellar: :any_skip_relocation, sonoma:         "591eea70edfd6bda48e19622994a455bfa6c94dab3f72498b50f3d97af660704"
    sha256 cellar: :any_skip_relocation, ventura:        "08bc6bb5e142ff7659f40306a7c7ac69c920009b81514d0b09058249fb14d93e"
    sha256 cellar: :any_skip_relocation, monterey:       "56b4595a4f4ba2a70ff463330c76220863cd7d92e4152401f69ce5aba1e2bcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ebe4387717497b7ea300b7311e58238a36776edf62662861f35b4175997b7a"
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