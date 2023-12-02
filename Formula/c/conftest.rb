class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://ghproxy.com/https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "a2a514438498b785e30a88075557ba7f29175256bc633404a40f699782ac55da"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1a7af2e2fbef6b5fe87b40151a3b4609c2a015716bb7de7ba1001a7156d98f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "215af6ef7d89f3e46b1485e36a7203324bb641fb50d490087a9fe67d21150dc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eacb77274b63cca6bfa11bd44a8c4d7a04378ccf7f6c2c286927e897832e4150"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1a60c3d78204125b605312df02448beafcc6b3e8b318e480ae9ad35af5a9d63"
    sha256 cellar: :any_skip_relocation, ventura:        "7c13222f7279b70617bc0dd6b76dc546958d783e53bdc16f3c7ea25481d2b9f2"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b0f06eaa214b35103218715c6687d6d0d9ffdadf3a0c9714f6b522294062f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3862914816726164c63f75b8043110e18fb84fee273bc576391261d7b3f9117f"
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