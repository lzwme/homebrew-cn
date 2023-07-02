class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://ghproxy.com/https://github.com/astronomer/astro-cli/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "fcd97a21e82938d41bda576fd7867ece9ea78675978c639aad572a5648fc645b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f881fc7ae751cf6943ef8ed2a3db64673cc5a2a193e46af7aefdf1ca5bce0629"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f881fc7ae751cf6943ef8ed2a3db64673cc5a2a193e46af7aefdf1ca5bce0629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f881fc7ae751cf6943ef8ed2a3db64673cc5a2a193e46af7aefdf1ca5bce0629"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6db327cba84a2905e0ce611cfabebe89c2a11d85dd4968afe05871791c6deb"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6db327cba84a2905e0ce611cfabebe89c2a11d85dd4968afe05871791c6deb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab6db327cba84a2905e0ce611cfabebe89c2a11d85dd4968afe05871791c6deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3b7baf8621e26658dd38572b6ca441ef12051b66270723855c8c49100c4ed6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end