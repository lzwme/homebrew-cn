class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghproxy.com/https://github.com/open-policy-agent/conftest/archive/v0.43.0.tar.gz"
  sha256 "58d4e0d00af5d42378eaaeeff85999fa764d983f713c52283f4d29e076f73725"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d208f237e446dd06f3b67a134a45451903c1f7a416a0df61c1656098baaab892"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d208f237e446dd06f3b67a134a45451903c1f7a416a0df61c1656098baaab892"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d208f237e446dd06f3b67a134a45451903c1f7a416a0df61c1656098baaab892"
    sha256 cellar: :any_skip_relocation, ventura:        "de707d22d4aeb226b864c3e075fea9fcfa5d4d31342fe009ba868599c2f50b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "de707d22d4aeb226b864c3e075fea9fcfa5d4d31342fe009ba868599c2f50b2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "de707d22d4aeb226b864c3e075fea9fcfa5d4d31342fe009ba868599c2f50b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc69d3b43a05a922cf6ad7364cf32317749b92efebd3296a051dcca46f7b90d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end