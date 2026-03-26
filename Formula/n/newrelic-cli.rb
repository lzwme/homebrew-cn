class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.1.tar.gz"
  sha256 "cf4b22590670b964de41b0e84383b22a429e8578764308ebfa01928fea638fc4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09416cb950329432cd649e6d84127429cbc112eecf8f5dd0ec67dda319f40e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8232b9a0a9179c17d40f25d6bb478a818aa8e765a2b3963d07138095e915b8fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c2f99ca17cd1ee78c9a07ef60d08340b6d11db9872580f01434d75c66107b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7342b08510dfac414cb92a6d5e736449cc1a71e55bc6213bd1dc8ebab3fa24db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855c341d850188d2fada41826416a6f9a6c31ec39c6ffc0f633d425fa8dbecf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2df809b2b0d5306cf10ea26f7fbb3cb4a9ad6ec16e9f9fa89c4943c3eb2de11c"
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