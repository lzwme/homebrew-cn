class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.31.0.tar.gz"
  sha256 "50a2994d760303119ce26081007d1c180a36c2cf47d995d0232ad27df11ec494"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0638b9dfff44818ae11438a036c2da643da1f5fc7c70e57cc3963404d680ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0638b9dfff44818ae11438a036c2da643da1f5fc7c70e57cc3963404d680ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a0638b9dfff44818ae11438a036c2da643da1f5fc7c70e57cc3963404d680ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "054066b19b79ff8088d26498a8463d4ec3a9815d0ef5eb3a9acc25f8e7c0f0bc"
    sha256 cellar: :any_skip_relocation, ventura:       "054066b19b79ff8088d26498a8463d4ec3a9815d0ef5eb3a9acc25f8e7c0f0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde35be597f90f75aa6758ee94eecff08f5ab1bf7891c4689bbd38724d6b92c6"
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