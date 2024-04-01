class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https:www.conftest.dev"
  url "https:github.comopen-policy-agentconftestarchiverefstagsv0.51.0.tar.gz"
  sha256 "d22b539e870d5f5bb2655297ddd431386ab869f5d08af14f8605a558f3f423a6"
  license "Apache-2.0"
  head "https:github.comopen-policy-agentconftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09412170aa8797241572650331e751dc8998a8912b65af89a684a1815de8e3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7c0c11dbe2e40eefd115d3026c1483f3531edf697b24698d7c93cb10c438808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e68af442e8acbd6aba06186aadf594c7ae85bcc8a3ee06ae826928131f5220b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d0aeb7c29b8518696f5fdf76eb4493dcc5205f13113f89fa7f85ec5b632f762"
    sha256 cellar: :any_skip_relocation, ventura:        "4e26b36f1b1a1c197896568c95e678aecd055fdc872ba7e990fa7bab29da5ea0"
    sha256 cellar: :any_skip_relocation, monterey:       "c560608942cd0e4d953dabc31888c7cea11610dc6b83dbde8e38e37d9fd9d81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e312913cb1c54584a95c00055aaf8e9d51d5625dc3cd1268a9f39e426aa860ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.comopen-policy-agentconftestinternalcommands.version=#{version}")

    generate_completions_from_executable(bin"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath"test.rego").write("package main")
    system "#{bin}conftest", "verify", "-p", "test.rego"
  end
end