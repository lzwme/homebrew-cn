class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.29.0.tar.gz"
  sha256 "e20ce010449fff88c2e57e3ca5e337a7f8704df7e6b2ac794019c4a720aeb659"
  license "Apache-2.0"
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb70b97a570bcdb1503221115d2cd9820b25139649976ecbfc8a6c1fdd56b9a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb70b97a570bcdb1503221115d2cd9820b25139649976ecbfc8a6c1fdd56b9a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb70b97a570bcdb1503221115d2cd9820b25139649976ecbfc8a6c1fdd56b9a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cad55750a432f015ccbf7f82c72292ac093e298341faf702778f3d4594f78b7"
    sha256 cellar: :any_skip_relocation, ventura:        "4cad55750a432f015ccbf7f82c72292ac093e298341faf702778f3d4594f78b7"
    sha256 cellar: :any_skip_relocation, monterey:       "4cad55750a432f015ccbf7f82c72292ac093e298341faf702778f3d4594f78b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "577619d2cebda08108a8b6cb16f591f34420fed10bea6c39747400e5181b0511"
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