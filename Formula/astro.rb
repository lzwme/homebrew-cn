class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "d9b5eeeab888553ed5a131dced06ba2be9d3bda507a4f548861007ced79a1cf4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3900344f4345eddf37a7d6efeb905d20a0400608c23c2565f84a2755d5a31ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3900344f4345eddf37a7d6efeb905d20a0400608c23c2565f84a2755d5a31ffb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3900344f4345eddf37a7d6efeb905d20a0400608c23c2565f84a2755d5a31ffb"
    sha256 cellar: :any_skip_relocation, ventura:        "94fc07934431eef94ee367f4aeb8580790a7e044652fd76c0883db11704a14da"
    sha256 cellar: :any_skip_relocation, monterey:       "94fc07934431eef94ee367f4aeb8580790a7e044652fd76c0883db11704a14da"
    sha256 cellar: :any_skip_relocation, big_sur:        "94fc07934431eef94ee367f4aeb8580790a7e044652fd76c0883db11704a14da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74535a7bce86d101d3d595398493666419a9589189d47f5842c778871d538b41"
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