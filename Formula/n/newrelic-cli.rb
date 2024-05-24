class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.86.0.tar.gz"
  sha256 "bd3604819a2cc959dae4ca893a5874eeffb692eb026495ee189b754bb1db425b"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "032ab2f7eb34d317c81d2ee9d8be4eae496c85f42740746eed498b6497c09cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "091402ea93dce93a3d6b72a87e3d67c4bdcb7ef35bd4f03af7e03615addd003d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d9a4eec4d98c479ea87a4d8b17cb68c2028e0475b8300cc990b853a94f9a1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f86328423e586415f1e0deb7c31adba28aac7dcefab065c3ae4e21114ac7b4f"
    sha256 cellar: :any_skip_relocation, ventura:        "b0a4171fe7e222127d23cbdfc4c8217302483e53b71a7c53b12c238371385a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "79fe8629f11f725598b13f1925dbb558391861be3663b61891fa5fa146d686bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e4626448950f03055519bbc48aa66de6f39e1a31f519eee4c1a5a14aa77a68"
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