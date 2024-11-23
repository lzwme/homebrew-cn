class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.31.0.tar.gz"
  sha256 "e2a3d50d29a8694d149739f7b967f6c6984a236621711afd6d0d495b9868d621"
  license "Apache-2.0"
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80b67eca0aa371f585e749b9c68bbad5f30a95ed3d7f5a6319ff6f6bc3beb047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b67eca0aa371f585e749b9c68bbad5f30a95ed3d7f5a6319ff6f6bc3beb047"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80b67eca0aa371f585e749b9c68bbad5f30a95ed3d7f5a6319ff6f6bc3beb047"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbbfd8b9625549666d37ecf9655dc8d05c2fec258190976ddf3df26f213285c1"
    sha256 cellar: :any_skip_relocation, ventura:       "bbbfd8b9625549666d37ecf9655dc8d05c2fec258190976ddf3df26f213285c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee8a99e7abc05c9ed5ca56ee3b979876b5e3b92271994bbadfc6d976353975d"
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