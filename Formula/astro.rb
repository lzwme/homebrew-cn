class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "c3fc356bc4100934aa75db58e4cf5e7c226ebc54c828f146f5a52390831dd2d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8699b76e5eea8a3fda0cd0a86b10112239dd9a495918aef51300a6fabd1996"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8699b76e5eea8a3fda0cd0a86b10112239dd9a495918aef51300a6fabd1996"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8699b76e5eea8a3fda0cd0a86b10112239dd9a495918aef51300a6fabd1996"
    sha256 cellar: :any_skip_relocation, ventura:        "29804d7ceb95d2c7cb5e1a44fdd952781ab1c0d5b76cb885577de2809222bfbe"
    sha256 cellar: :any_skip_relocation, monterey:       "29804d7ceb95d2c7cb5e1a44fdd952781ab1c0d5b76cb885577de2809222bfbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "29804d7ceb95d2c7cb5e1a44fdd952781ab1c0d5b76cb885577de2809222bfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a21fc8157d5937ac07b564d2f8dc38f160a19631eb559e5c915f1ba86827ae"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end