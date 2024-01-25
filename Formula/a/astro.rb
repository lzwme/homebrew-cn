class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.22.0.tar.gz"
  sha256 "64a63f75829f5a7b3840253a044dcbde5b37e90b6e012133b087a27980454b41"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d147ca087465eaecbd4b21c5ebbcbb58e111e30e7c94a6d73bd0a4e1ed2b18d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d147ca087465eaecbd4b21c5ebbcbb58e111e30e7c94a6d73bd0a4e1ed2b18d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d147ca087465eaecbd4b21c5ebbcbb58e111e30e7c94a6d73bd0a4e1ed2b18d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bc1b8e97ed133cce95ce6f88c42088ace115deaa8c41ac3f5e7f9432a9ff27d"
    sha256 cellar: :any_skip_relocation, ventura:        "9bc1b8e97ed133cce95ce6f88c42088ace115deaa8c41ac3f5e7f9432a9ff27d"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc1b8e97ed133cce95ce6f88c42088ace115deaa8c41ac3f5e7f9432a9ff27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c1b3ff9a2cddcf0b6e146b3b539856933dadb07c7231f33927f99807def661"
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