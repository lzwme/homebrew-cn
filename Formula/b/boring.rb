class Boring < Formula
  desc "`boring` SSH tunnel manager"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.6.0.tar.gz"
  sha256 "460b007759ab2956da2b0f56478cff1574dc668791842c55aa9c2e2c25b03a3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3542db45abbb02972370f48346ad52941fdb0b7983f6a55cf90785b1cc1a6c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3542db45abbb02972370f48346ad52941fdb0b7983f6a55cf90785b1cc1a6c8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3542db45abbb02972370f48346ad52941fdb0b7983f6a55cf90785b1cc1a6c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2abab54176d5aa084f54d4165dce4d613e6219e412a387f45a873c3cd1d2d2e"
    sha256 cellar: :any_skip_relocation, ventura:       "a2abab54176d5aa084f54d4165dce4d613e6219e412a387f45a873c3cd1d2d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b1476f4eeb5b3f49e8a4efdeb9642b468da9f36674202d7b4b79d098337c6d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdboring"
  end

  test do
    assert_match version.to_s, shell_output(bin"boring", 1)

    # first interaction with boring should create the user config file
    # and correctly output that no tunnels are currently configured
    output = shell_output("#{bin}boring list")
    assert output.end_with?("No tunnels configured.\n")
    assert_predicate testpath".boring.toml", :exist?

    # now add an example tunnel and check that it is parsed correctly
    test_config = testpath".boring.toml"
    test_config.write <<~EOF, mode: "a+"
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    EOF
    output = shell_output("#{bin}boring list")
    assert_match "dev   9000   ->  localhost:9000  dev-server", output
  end
end