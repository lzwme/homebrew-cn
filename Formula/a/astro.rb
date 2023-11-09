class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "ec4284c917f2abf1f952a1dd4c57f3c33b7809d0e2fd5482472e1b1abbba45ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd9a2460a7965926a1b97ba0df8f2c3d12b498ff07521b55f229a02f1c95086a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9a2460a7965926a1b97ba0df8f2c3d12b498ff07521b55f229a02f1c95086a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd9a2460a7965926a1b97ba0df8f2c3d12b498ff07521b55f229a02f1c95086a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5520897621f059915911bae8d1b2442b164adb8005716707030be19591f89e59"
    sha256 cellar: :any_skip_relocation, ventura:        "5520897621f059915911bae8d1b2442b164adb8005716707030be19591f89e59"
    sha256 cellar: :any_skip_relocation, monterey:       "5520897621f059915911bae8d1b2442b164adb8005716707030be19591f89e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd557469193027051c0d5b22173cf1df0a5d3a64b708ad894d33a0f59ffbcbb"
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