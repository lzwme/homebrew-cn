class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.95.0.tar.gz"
  sha256 "b8c83e1ed13b01e7e8bc083f91a70cc684d684c2d2ce234624f1b618bc8fba4c"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f27b3cd9976e8cb28509a59026fc84f4da4e638fba08cbc6b7cc6c87cf0ee98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bb2eb3b7bea2b259f912f20c20d526d1655a06bdebfcba88a1e3096be46a79b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1273164d1c2482e78068eb0880174d98b1eef97d156ba7755d2767554aeaf6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee277b3e4299cdca1b39b259687e274f7868a6b0b151d50d0c1b5f720cd35ece"
    sha256 cellar: :any_skip_relocation, ventura:       "e31256c1d9c8efbaa13f8c3646e6e4ea84236b470ec138904a993342facf8c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda7f1dca3bfe8b72aa9503870c7b585304e88f47488b6f0f138ac41224340de"
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