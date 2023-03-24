class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "11318607c74887c44dbbc92751591478b57c72023f0a824a158efec7ae97d534"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "001a6c45f5abb0ad40fb7b7e3ab71a8840565acdc81d7c93b52fef4216eaf4fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "001a6c45f5abb0ad40fb7b7e3ab71a8840565acdc81d7c93b52fef4216eaf4fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "001a6c45f5abb0ad40fb7b7e3ab71a8840565acdc81d7c93b52fef4216eaf4fc"
    sha256 cellar: :any_skip_relocation, ventura:        "8274e7a5856400f94e050ec44c7162cb02e6c4561f2e3d37cef2f560200d5c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "8274e7a5856400f94e050ec44c7162cb02e6c4561f2e3d37cef2f560200d5c2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8274e7a5856400f94e050ec44c7162cb02e6c4561f2e3d37cef2f560200d5c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47eb4ee666dd5c3c281bbd1da16b09e6e24e0dc023734da0062261844f71a906"
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