class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.28.3.tar.gz"
  sha256 "59a271d26fe1cc34f8489417794781a0da0f1d47eaf00626e3490ae3451bc7c7"
  license "Apache-2.0"
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f51aeba6df75abd4d4b8aec295dcddf3c9900329b81248adb31db13d5640bcfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e3b0cd4f3d4797dacd28c2327dcd13875b32ccd73d6f6f39d22905a916eccbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bcd7c48fc07d71e48f00ae2fd9a56cdac2911f20710eaedf47d51badb73b989"
    sha256 cellar: :any_skip_relocation, sonoma:         "818bdaec327593ad1f08ec1c4ce4e1e7604a6dcc6ea71be9ef02d51e2b056995"
    sha256 cellar: :any_skip_relocation, ventura:        "60fd438e2271f33b4c5ad78eb3379e077e11bd1123e32830c6cc5e87ee94690c"
    sha256 cellar: :any_skip_relocation, monterey:       "cd788bf5a75a03796b31952e19d63c0ad20d43bc7f653f04689601d1b4ef01a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65786da522348bcd7995a626872e97aa2740322e25a6b3b4f90ec47ad1a7a7f2"
  end

  depends_on "go" => :build

  resource "terraform" do
    # https:www.hashicorp.combloghashicorp-adopts-business-source-license
    # Do not update terraform, it switched to the BUSL license
    # Waiting for https:github.comrunatlantisatlantisissues3741
    url "https:github.comhashicorpterraformarchiverefstagsv1.5.7.tar.gz"
    sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
  end

  def install
    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec"binterraform")
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec"binatlantis")

    (bin"atlantis").write_env_script libexec"binatlantis", PATH: libexec"bin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}atlantis version")
    port = free_port
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin"atlantis server --atlantis-url http:invalid --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http:localhost:#{port}' 2>&1`
    assert_match %r{HTTP1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end