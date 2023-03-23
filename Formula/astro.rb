class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "05b660791acd2a92161a333b1b648ad0c991edf1af89f598487dc976a7d1e5cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81595508c35074b4621655ba0e5062a412a49a5a04a072edeca708cd601607fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81595508c35074b4621655ba0e5062a412a49a5a04a072edeca708cd601607fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81595508c35074b4621655ba0e5062a412a49a5a04a072edeca708cd601607fc"
    sha256 cellar: :any_skip_relocation, ventura:        "0369b16c2ee8fb9d4ebb5a1e7bb55a0135eaab6d11780037369547e3b654c86b"
    sha256 cellar: :any_skip_relocation, monterey:       "0369b16c2ee8fb9d4ebb5a1e7bb55a0135eaab6d11780037369547e3b654c86b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0369b16c2ee8fb9d4ebb5a1e7bb55a0135eaab6d11780037369547e3b654c86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3006bb818940d53f064d353798496a3a417b2a972d84caa251cea31c56801a"
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