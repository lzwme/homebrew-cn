class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghfast.top/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "6a468e1ba0b0d87653299d7a7e299a300fb8b6841d58c6fd6c6efc0ad95a8546"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5273601166e7d934a15bc3ca27010985512d4b94b3771377ed4fb03f09688ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7530b08d75a9844f9c693fee18a1efe3609f99f24f2693acccf09f1b3dcedb50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be629016fdc22bbc2cc367d5cfd5429f4254d952d76c505b93793e98a3fe822b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f99d4430243fabcd720a6f38e8f50a7b413c8598d9aaf6851302433cfdb8244"
    sha256 cellar: :any,                 x86_64_linux:  "eaf89b151fdabd860971731c4c4a0826d73369d5ea5f9a8aa332a9ef6ed2d5f6"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

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