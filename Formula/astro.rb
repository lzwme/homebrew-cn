class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "6c3837e3ac7ce6efc7de1f99cebf85fcf640f13d5315643c97aecf3e3522ee1c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0027e7c8c23b81543ae9085c663fde93c875af44b1e3e1e9b21e3980c70cfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af0027e7c8c23b81543ae9085c663fde93c875af44b1e3e1e9b21e3980c70cfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af0027e7c8c23b81543ae9085c663fde93c875af44b1e3e1e9b21e3980c70cfb"
    sha256 cellar: :any_skip_relocation, ventura:        "4a4261d53dee89c637ca86573a749b535999d3bc49c9317eec533d0f7bc3386d"
    sha256 cellar: :any_skip_relocation, monterey:       "4a4261d53dee89c637ca86573a749b535999d3bc49c9317eec533d0f7bc3386d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a4261d53dee89c637ca86573a749b535999d3bc49c9317eec533d0f7bc3386d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3033db1401482f7c32c56ee5b991894ddb1af53fa1126372559265d90f0098"
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