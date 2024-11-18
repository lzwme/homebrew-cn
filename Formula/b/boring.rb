class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.8.0.tar.gz"
  sha256 "378f6bb1becb6d5a90a086306ba22a3bafa12f7f796f94e739d873d2cce41601"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f1535d54c08e5704412485bbe340894b4be38cf42362b3cfee36cd99236227d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f1535d54c08e5704412485bbe340894b4be38cf42362b3cfee36cd99236227d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f1535d54c08e5704412485bbe340894b4be38cf42362b3cfee36cd99236227d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56983107e47e4e9da688c8fc3aa2abdd4fffba4942cbe6990f7993bed243aec0"
    sha256 cellar: :any_skip_relocation, ventura:       "56983107e47e4e9da688c8fc3aa2abdd4fffba4942cbe6990f7993bed243aec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601d2506c354e0ceaa4baba58b9ad03cb6bc3b40616ed5bd3bdc1a97dc655fa8"
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