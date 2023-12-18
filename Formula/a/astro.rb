class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.21.0.tar.gz"
  sha256 "cb303df149815f873dc405497c4f67c3760fccc5ecafcf67a32f41dfc56d6e4c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fce7d69a37fc358058e450cc32dac9112d38bbfc29ab69d4a3f872e57509d1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fce7d69a37fc358058e450cc32dac9112d38bbfc29ab69d4a3f872e57509d1e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce7d69a37fc358058e450cc32dac9112d38bbfc29ab69d4a3f872e57509d1e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9d444dbb5da9d4ea848525c2c196803e443c2e0b8c7f4175bfbe3c722063a65"
    sha256 cellar: :any_skip_relocation, ventura:        "e9d444dbb5da9d4ea848525c2c196803e443c2e0b8c7f4175bfbe3c722063a65"
    sha256 cellar: :any_skip_relocation, monterey:       "e9d444dbb5da9d4ea848525c2c196803e443c2e0b8c7f4175bfbe3c722063a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532bc4f134257fd6cf8bcc8ef45e3756b72041aaf45e0d64a4d408269feba91c"
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