class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.66.0.tar.gz"
  sha256 "59e257112ca79271161151556313c590cf3ada7a4e9bbffd3a3dea0378534d2f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9cd3dbfecb19ce0df545575debc19ae82d9cc0733c69caa52a90d5085e9f8d7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d179835ac871da69bd9c71f426011c296d0ac2968be23cb730d21d1b3c1ce23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f68c5c4afc9730e05b7e60c21205a6d1ab7411028d6a7e1f6dcfc4655dce8e7"
    sha256 cellar: :any,                 arm64_linux:       "cd2843edd70346451aa23de5205bc5a3349e7e62febabc5206c68e1b3b6f5677"
    sha256 cellar: :any,                 x86_64_linux:      "524ef5dff89c770b10ce36e5276154313df500ad7eeac8af8a81455256313d87"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end