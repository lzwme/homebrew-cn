class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.24.0.tar.gz"
  sha256 "9454e4d2da68ae38e348575f4319d40a70310fa8e21db667744e5f74b83103c6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fad044da3e1c09551288fda1925105efa5f2c46be538299f9dff01b5a3ef0f6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fad044da3e1c09551288fda1925105efa5f2c46be538299f9dff01b5a3ef0f6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad044da3e1c09551288fda1925105efa5f2c46be538299f9dff01b5a3ef0f6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a58f2a80ebdb0e4c86e67d3df91a61b8c5b5f92d5420298b9a6594e252f889a6"
    sha256 cellar: :any_skip_relocation, ventura:        "a58f2a80ebdb0e4c86e67d3df91a61b8c5b5f92d5420298b9a6594e252f889a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a58f2a80ebdb0e4c86e67d3df91a61b8c5b5f92d5420298b9a6594e252f889a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce16d59c35fa0e9e2a06c60b38cc8e58d1412011cbec200e7544e1a20a06358"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comastronomerastro-cliversion.CurrVersion=#{version}")

    generate_completions_from_executable(bin"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}astro dev init")
    assert_match(^Initializing Astro project*, run_output)
    assert_predicate testpath".astroconfig.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}astro login astronomer.io --token-login=test", 1)
    assert_match(^Welcome to the Astro CLI*, run_output)
  end
end