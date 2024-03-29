class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.25.0.tar.gz"
  sha256 "44e9cb81206a44f0b80cf5566d1420df1771904507855f69e659d450aeecd6f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b34fbc177008f022d862e2ed9cf1e1c3c7473fd528e11b9fd9153356573c760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b34fbc177008f022d862e2ed9cf1e1c3c7473fd528e11b9fd9153356573c760"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b34fbc177008f022d862e2ed9cf1e1c3c7473fd528e11b9fd9153356573c760"
    sha256 cellar: :any_skip_relocation, sonoma:         "748c66a7f3f76c63038d26dac5bb76cb54739d720b1b5b1bf9942a69bf40723e"
    sha256 cellar: :any_skip_relocation, ventura:        "748c66a7f3f76c63038d26dac5bb76cb54739d720b1b5b1bf9942a69bf40723e"
    sha256 cellar: :any_skip_relocation, monterey:       "748c66a7f3f76c63038d26dac5bb76cb54739d720b1b5b1bf9942a69bf40723e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb7330c50efa22cc58116f710150732f4e9fb442ec06a3b84eb557b499262e0"
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