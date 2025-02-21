class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.33.1.tar.gz"
  sha256 "4e208bfbe427c5c3a4f94b56533d4202c9c9c6c24b0ac3396edf36bb3252da66"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a90c0fddcdd55bd99ce71660a801dec9e9b9a3d41dcde3ffe94adf0c3fb3282d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be993b2a77a46a905b6e34cdf7c43fd53eba6b9df1e9147e96d90bcfdd7ebad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "642215224367ca858911c80416bb06639ee84cd17937c14a06afd5e55b1ca0bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c5f6492df273dcb3cf9a57c02db5b2b49ea55376353b05298c3c98e6726794"
    sha256 cellar: :any_skip_relocation, ventura:       "a1ab8a899172dc0bd07b12786432cf074a8c9b356278928926125106cbf3efe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e86546ff0a2f8a207a4e5835f30b4428ddee60881a267f3db05d8b5e562614"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
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