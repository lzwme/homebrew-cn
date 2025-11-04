class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghfast.top/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "90b4c6cafc58d79b2baa418e397fa2b52d577b22c70e7812b365c3ae6d6fc7f2"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf147c75310ae02c19643e336cdde4a014f637bcfaa551629f03958fda34b434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be5577394136010b2dd8b25ecbb15f7d204d19b7eb5a1dc06e949aab49ab383a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f4edca4abbf3a8c4d4e9312551bde98a30c35c494f4a66a61e2a0a7eb198eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "920dd9a48cf82d54fc2913d63a2392930dd9ad41e097618cf9801a6c42253cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d975fb0afbbe086dd04e44722d260a7b14e9723290b925e0817db891a6d324b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00308b71058abf3022e2909edd44a5b13acc46e56c10cbf1fbd64ce8e655f043"
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