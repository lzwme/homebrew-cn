class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "8fcabf2a63daf1ad9ea2258cbd3d557915d57f1327b3ce5469ad45f019915283"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5166127cef2f3b4c3828df8a9b4411b571919804d623f9e9f61ebb60ab1dc30f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5166127cef2f3b4c3828df8a9b4411b571919804d623f9e9f61ebb60ab1dc30f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5166127cef2f3b4c3828df8a9b4411b571919804d623f9e9f61ebb60ab1dc30f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc763b4d8702b1e91263c18a94d9223a46b0b85a5caa2e0f4c71247bf95e7423"
    sha256 cellar: :any_skip_relocation, monterey:       "dc763b4d8702b1e91263c18a94d9223a46b0b85a5caa2e0f4c71247bf95e7423"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc763b4d8702b1e91263c18a94d9223a46b0b85a5caa2e0f4c71247bf95e7423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e68d44981073a126de019df1bd7c1fa2102334fe079de1ec636ec6c4d15f06"
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