class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.28.4.tar.gz"
  sha256 "7ca2308d562598c798a8dd446df2e2603f3d626fa2a749c4e00e259c0aad6300"
  license "Apache-2.0"
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71910d2d25b3d5bfa603450b81f40b93e8de4dad690fc8a2895c2bb4896dd165"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f6704c6a41f5821162ad5c438ff722ec8bcb25cd8d77d0c205796fc4742eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3b37ea463843752fd1a4a7fdbd3634dbac97d9076cb3ee9282d324e0348d349"
    sha256 cellar: :any_skip_relocation, sonoma:         "1218266d61cca2ee1fb0d5bc93d2df8b0816c60123533b7ec88efbd563b5726a"
    sha256 cellar: :any_skip_relocation, ventura:        "80110f73a782531e4deee00dd9ab1ffbbf52011861b143c01331ce5d0565285b"
    sha256 cellar: :any_skip_relocation, monterey:       "cba2dce40839e2fcecd782e8b359136468cca3ab8216fc6f2906c2bda02dcd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50cff6e2d32cc40661cd395aa3a3ec6c1c06068fbd5fd4beb24ff8bae9a1b329"
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