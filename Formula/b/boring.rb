class Boring < Formula
  desc "`boring` SSH tunnel manager"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.7.0.tar.gz"
  sha256 "ea04fc196d8c29fa4f533a6ecb2d3feeecbefea3f6b6bb614416612f05a3b1af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1943f78258182e7ef90a4ec29942063bf913a0d55745ff2e773da1635374fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1943f78258182e7ef90a4ec29942063bf913a0d55745ff2e773da1635374fa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1943f78258182e7ef90a4ec29942063bf913a0d55745ff2e773da1635374fa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "438bc38faa04cc42b90b7a6ad7ef819b879931ccbbddb0dbc140a7bf270e04b0"
    sha256 cellar: :any_skip_relocation, ventura:       "438bc38faa04cc42b90b7a6ad7ef819b879931ccbbddb0dbc140a7bf270e04b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7d48f7f20c80d1e006102e99e1c3be3466f6cd33ef4ae70e0229245037068f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdboring"
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    assert_match version.to_s, shell_output(bin"boring", 1)

    # first interaction with boring should create the user config file
    # and correctly output that no tunnels are currently configured
    test_config = testpath".boring.toml"
    ENV["BORING_CONFIG"] = test_config
    output = shell_output("#{bin}boring list")
    assert output.end_with?("No tunnels configured.\n")
    assert_predicate test_config, :exist?

    # now add an example tunnel and check that it is parsed correctly
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