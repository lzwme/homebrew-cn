class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.99.3.tar.gz"
  sha256 "29a3512f028482462f557346b4a726b0a3a555d3d7a6968facf4e7733eeb04bd"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc4ab22fad691c510181a4292de0e3f5e5defb328022d7da839cc8eebc9c9db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a670c21ae29114296116305d143e92080edb9a392f9f27dc6b66df17caabd5b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a229afcf8030fe2eeb263ae3e3c20f0e74966d54259ef71ef927c9b98265565b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed20141830a8390a179aabc41702fe87161f82314bfbdf89ae6656fa02b6d19b"
    sha256 cellar: :any_skip_relocation, ventura:       "937d6fee1b3dc25d591d6957689c96c3a8409c40bd9a99fe101fa378bf4a17b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56361b343b9d0dbd95f248acd20d000753db71d775e7a70d150b815c41232234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc968a078a681fa3b47b88bb002618e015ab130c33b61ecd683c90ed866dab10"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end