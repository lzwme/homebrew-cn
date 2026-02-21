class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghfast.top/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "a4f31da92a9d6faffdec6f83a61011c8058822cb2081321a0a1ae1af54a88304"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7028c49d04ef8ff6e7858aaf613c336d62b681ccf91f4f8e04a0b9985292770b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb4fb52b48ec94ec7e864da15a497b5ebedf27e76bbb4ff188b92414a5df9ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64e631736a99023a3fde84c2d21d6d14d69af05f994f53662cb59b5d0c9de23"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce247832ee904507be764f003bf2107b6a620c187ea20335b407d765f331f953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92d1daf49c0ec3ac962da87ac9ed288655cc2d978efa9f61906e00ffd7d44a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d8be158ffb018a93e956ee08fbe1a1fe0e66f52d308bf381e7a93f20570504"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", shell_parameter_format: :cobra)
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

    run_output = pipe_output("#{bin}/astro login astronomer.io --token-login=test", "test@invalid.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end