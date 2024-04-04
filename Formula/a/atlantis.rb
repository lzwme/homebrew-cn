class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.27.2.tar.gz"
  sha256 "e44a53d4fa43cdaa88a2e7734da2854a97b1b555a425ab26ac5787ef9f3d3076"
  license "Apache-2.0"
  revision 1
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8845a4c5c5fec862421b6ac27d9ff8b9e31e396efa1c40057fc7db430690e93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1d52f85b02755ff8bbe196a77712a4688df129bf02dba756f1e6ac0a2b9d260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07809a2647989121d6a929ab5a8f7344a2f13bcc6e029f1a0219dca6ab9d200e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a028543e426c3f8ae015deabcf7f8f1103e7c4cb9e02efce93d569593b9f2179"
    sha256 cellar: :any_skip_relocation, ventura:        "dd6ee28da1ffbda533aa0154ada6c6a4d5d9684998ab351ebed6181e979eeae6"
    sha256 cellar: :any_skip_relocation, monterey:       "a7b370e28a832dad0377cec8624ebe9f76c9dac817dcd9fa1c665ef3a035b4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12a6068bf37a14576b2b45311dddc82006a308765aea858322835e397d06648"
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

    system "go", "build", *std_go_args(ldflags: "-s -w", output: libexec"binatlantis")

    env = { PATH: libexec"bin" }
    (bin"atlantis").write_env_script libexec"binatlantis", env
  end

  test do
    system bin"atlantis", "version"
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