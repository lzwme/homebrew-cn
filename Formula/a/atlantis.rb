class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https:www.runatlantis.io"
  url "https:github.comrunatlantisatlantisarchiverefstagsv0.28.0.tar.gz"
  sha256 "4673eaf6e92d540a228c18db581de9c504e9777b4547a781be9042347f7f9686"
  license "Apache-2.0"
  head "https:github.comrunatlantisatlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e952cf0aa0372e94599da54cd46e0914dc7c94d68b117af12a602f4f7f7a284"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab65d5dff380fc45c5593d86add451c90499d4e8e09e4a136bdf35a000370345"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbad73c2545ef4a21378caf0e96d3eb1cf606d2907dec341f26a25d3f584f455"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea373989a919b95d18d1f5b491d30a8e3babb84d5359eb7fe905960219208b41"
    sha256 cellar: :any_skip_relocation, ventura:        "a3cad272ae6016b6ce014878822c7e4dcc670d10e2b6dd8d966e778cd6cc9bf4"
    sha256 cellar: :any_skip_relocation, monterey:       "7ccd540ecb42742152707310fa9fac94da45fc4e4a075b887a7778ad54b2e6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d7a9b914751de4cc092b57ffed88e1c17d592778337f65e8e6273c0a76edbb"
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