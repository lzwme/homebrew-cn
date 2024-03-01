class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https:www.astronomer.io"
  url "https:github.comastronomerastro-cliarchiverefstagsv1.24.1.tar.gz"
  sha256 "e03b7f4f9c3c14bb0787c8c012417ef73f8e9481ea1aeabac3d64eec423d9498"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89a87ab3295e71232feb71f91d68455babd3cb437688f4ab2bec4cdb5cc7a055"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89a87ab3295e71232feb71f91d68455babd3cb437688f4ab2bec4cdb5cc7a055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a87ab3295e71232feb71f91d68455babd3cb437688f4ab2bec4cdb5cc7a055"
    sha256 cellar: :any_skip_relocation, sonoma:         "d240d806985debac4a7ee1911fb8ca4bbf86809f6f354749f7084cb43d5c06d3"
    sha256 cellar: :any_skip_relocation, ventura:        "d240d806985debac4a7ee1911fb8ca4bbf86809f6f354749f7084cb43d5c06d3"
    sha256 cellar: :any_skip_relocation, monterey:       "d240d806985debac4a7ee1911fb8ca4bbf86809f6f354749f7084cb43d5c06d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d36ef2dbee52a3177dec29a0111a7bd972d342066477e8cb6008f8a3deb856a"
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