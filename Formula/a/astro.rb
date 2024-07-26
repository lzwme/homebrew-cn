class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.28.0.tar.gz"
  sha256 "b5ee52be272202fccc07045e9b305cbb7a98f5b3485e022e2fbb5694c2966b25"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71f88cffdf9625818a98fc9e61f77cbd99cf1d7dd0889ab4a25232b541fef551"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71f88cffdf9625818a98fc9e61f77cbd99cf1d7dd0889ab4a25232b541fef551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f88cffdf9625818a98fc9e61f77cbd99cf1d7dd0889ab4a25232b541fef551"
    sha256 cellar: :any_skip_relocation, sonoma:         "d36d01cce66fa5c2707452271c02b604659498521f5685d666df0f53f6d85044"
    sha256 cellar: :any_skip_relocation, ventura:        "8427fac021a77f73aa0947cfb2b12e8d39bce7169c6f7432e23eaab8eda6f970"
    sha256 cellar: :any_skip_relocation, monterey:       "d36d01cce66fa5c2707452271c02b604659498521f5685d666df0f53f6d85044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ddbf23b9dbd98670a844239f844a2e682755b16593841f68415c5ff850a891"
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