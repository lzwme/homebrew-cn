class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.0.2.tar.gz"
  sha256 "e15b69118e5b4ea774c41dd63583466a5197a645c31bdd9c205617a29aa48d74"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "542d1cd1e08f71cd629104c97e40fb12552e51a387d9858716501851f63e8073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51a680ebe5b8ef8e67000a8438bfd73f756a1007bf6a2c44e9f9efcf955d6b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "807689077ed911b2477febe80a9fc0d76541b727d3a66094259b37ece7407b6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ecae68f369c039c3680bfc7e77cf1febda85988b29bdd8df773427166939d24"
    sha256 cellar: :any_skip_relocation, ventura:        "aaaecbf42dbe2964bb2dc95179cd7b0caf4805a2c336c13adfdcf4069c5d2170"
    sha256 cellar: :any_skip_relocation, monterey:       "9f732ed6425514a3d46a7af42899b2c5dad704961773b0ca20109828aadebd92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a937b97872e60618068ec68ddb85d527c9e64fad31f38bb90d73e0b4cad19995"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_equal "[]", output
  end
end