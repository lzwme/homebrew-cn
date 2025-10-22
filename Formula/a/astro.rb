class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghfast.top/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "87c0f66a7a0af4759f44a7786b9969aaaac2913031550fd2e48fdd3330feb7ea"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d1ade23e9ab58df0168c76723ac89385e668aa8be9099367cb30e3142c78258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cfef07ac0cc11ba4db1f09969e6cd48aed0f0b6eb3fcb7a23d9ae7102718bc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e19655fb7ff6c1ee65d6c2b01e439edacd518fb90f50ec4e1a01254176a6e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f64730829093536f862bf9156b6985827993f288bc9081874de704d27b9657c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01f2ba7c5a2ce21c75924c33bbd8524c90630fe727f4fc3008913f4f86ee0431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec7c230446e89fa9ee8776ecbf48a8d24e1ff3086b6c91ad6092b4a9feaa9d9"
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