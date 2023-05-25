class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.10.tar.gz"
  sha256 "3a29c392264fcce6ed5feffa61d4acd0e36c59858a208febc4fc86b84cbef4a7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b807e3e51d554ad19d72b06454f28463e46f32558a602e6041b824a4977fe8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d6467acadeaafb891c06fc0acd74434ee687a97e8239166db28ce9c7f03b200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c87cbcd196e0cff48a9339b3c42a813548ed26e14086753666e175605a1e6cb8"
    sha256 cellar: :any_skip_relocation, ventura:        "b569566d029ce914788e071f0cec1a99f074c87a3d6ad6488c52af1b5341ec93"
    sha256 cellar: :any_skip_relocation, monterey:       "22ebe9b0d0bfdeace16899e4bb5e5b82602ea3d4eda9db4dab7606ef12cd1a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0947a52e897be8e5f30ea53076fa3f75deef98a3b570ee24c858977a0c933b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e17bdbc718fedaf525264bda3cfe9ede72f04605280dca1d558f7067b9653f"
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