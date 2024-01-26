class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.4.tar.gz"
  sha256 "cf95f1a807fad5a30beb81b31a3b8758792aab3b6c516e34e609103efe32e3db"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e803692b399eb78825aeb7be61e8f24603bd221dce6c2e96bfde266508aca380"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "670d6492b12130d8d4be3d82883ba7fa369cec26e4be62f41d6587526be87a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43f0feca90860f082fb02eebcbdd21bab1025a3979fefe16b19e4481bb806e96"
    sha256 cellar: :any_skip_relocation, sonoma:         "41efa7ffac8aa2a05afd01777ebba786df58d6b41988c20ce17fad668e1bb92a"
    sha256 cellar: :any_skip_relocation, ventura:        "9bbaedf49fbc3e9f4852a27e84b4316a07f9f8ec57e22e8e65f8e4bb9ed369c9"
    sha256 cellar: :any_skip_relocation, monterey:       "f220d8283a0ff60f49b13190296ec0cb6b18f16ba813e9e6d8289cfd435163f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a949cd34c8a65a1dacb4741abee0372f0927854c3317ad8f55212df0e91c639b"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end