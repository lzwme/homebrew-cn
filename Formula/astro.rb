class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "42462eb51cb4bca898ea0706a911b32390dbf1251176a191373505b5c891cd66"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8137a0d7b33351d09a8be3e248d7b52eb3342dff86ea4a95d4c8d7fc9a9fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f8137a0d7b33351d09a8be3e248d7b52eb3342dff86ea4a95d4c8d7fc9a9fba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f8137a0d7b33351d09a8be3e248d7b52eb3342dff86ea4a95d4c8d7fc9a9fba"
    sha256 cellar: :any_skip_relocation, ventura:        "7631ecd879cea069c97cf525d5ff7c49c2c136c21fe1fda490206ff0b0e850e8"
    sha256 cellar: :any_skip_relocation, monterey:       "7631ecd879cea069c97cf525d5ff7c49c2c136c21fe1fda490206ff0b0e850e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7631ecd879cea069c97cf525d5ff7c49c2c136c21fe1fda490206ff0b0e850e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b33bcafa7285b46a5cde026321dc4c51a3c66547c61f739c496625f78e3f2d1"
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