class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.32.0.tar.gz"
  sha256 "96e83b74a23001268c3ae567ea45cc794164f8cc839b65cd6fad1283447d0c95"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c022483fdb6a914163d558b7e68c1b6310b22902fdee1c7d6bb99c833051211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c022483fdb6a914163d558b7e68c1b6310b22902fdee1c7d6bb99c833051211"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c022483fdb6a914163d558b7e68c1b6310b22902fdee1c7d6bb99c833051211"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb235270906fffaefe110e698a96b55adf519860372900ab9871319c4a7897f"
    sha256 cellar: :any_skip_relocation, ventura:       "ecb235270906fffaefe110e698a96b55adf519860372900ab9871319c4a7897f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f856559d2bb5873f315fffce6bf4a7d0f923cddcde55db6de76ac78acbda82"
  end

  depends_on "go" => :build
  on_macos do
    depends_on "podman"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comastronomerastro-cliversion.CurrVersion=#{version}")

    generate_completions_from_executable(bin"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    mkdir testpath"astro-project"
    cd testpath"astro-project" do
      run_output = shell_output("#{bin}astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath".astroconfig.yaml"
    end

    run_output = shell_output("echo 'test@invalid.io' | #{bin}astro login astronomer.io --token-login=test", 1)
    assert_match(^Welcome to the Astro CLI*, run_output)
  end
end