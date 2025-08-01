class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghfast.top/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "f2c58570d61cfcc7d26c671d07a91b0cf4c282e1966cfc947f624945308cf7c9"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3741aa326149e343a2aac5c2c27bd9e19fe6ae6b8d36d81e1ecc5be0f8af7a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0881c6fcd4c87e5ecdc1feaa04a84b51b62b60ea95aaad26005810a307f9cca6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bed941d0eb175daf72047c0cd01ae235510496c1b1abab78fd42a43ab570cfb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8dd20adfcaadae3fe96dc2236d2afa1ace1168449564db781a4101b14248669"
    sha256 cellar: :any_skip_relocation, ventura:       "73d95c0a2bab59ad8be3ca78f66430b6605617b4d8171f91f326d6b9e0c54a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40bb8dde9b62d18d3ec3682e5fc596fd1f6f9a97b14a341524eb05718de53d1"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    mkdir testpath/"astro-project"
    cd testpath/"astro-project" do
      run_output = shell_output("#{bin}/astro config set -g container.binary podman")
      assert_match "Setting container.binary to podman successfully", run_output
      run_output = shell_output("#{bin}/astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath/".astro/config.yaml"
    end

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end