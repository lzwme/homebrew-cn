class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghfast.top/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "ceb62ebdcb88ec733ab2ca8ffe25d593aca55dc5cc05c28c785939bf2f77c7ab"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86f1ce85902678f56f9bcb6c467ddb4b6c3c52db0d22beeac554eb1afdaa7acf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2c5c63f416d86170251fd48d40f292589a8dec97e36baa71d674e62cd0e5023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bbf3f7938ffaba94eb0331b82979702804263a9d017916250f91656c73e1bc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4dd2112fab1d2af63a1bb4c416156836576c33e603a985fc5aac7d89327649b5"
    sha256 cellar: :any,                 x86_64_linux:      "cb2bf1d5eab715583b4d0c45ca9dcd5e383b43d669d1d7cb199171befed717aa"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  # `test do` block queries updates.astronomer.io
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
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