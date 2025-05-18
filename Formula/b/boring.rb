class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.11.3.tar.gz"
  sha256 "2c2e39f2908bf1a227b530b043f2ba493dbc4e9060ef303ebd553f5702ca87d2"
  license "MIT"
  head "https:github.comalebeckboring.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "501565d73f5eddd0150fdb3064dee38fd5264e249961138712aebff0fe7ae0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "501565d73f5eddd0150fdb3064dee38fd5264e249961138712aebff0fe7ae0dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "501565d73f5eddd0150fdb3064dee38fd5264e249961138712aebff0fe7ae0dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2360d397c2a077997d30d1a7ff950cd965bce1b284c7954048994c4f27862b17"
    sha256 cellar: :any_skip_relocation, ventura:       "2360d397c2a077997d30d1a7ff950cd965bce1b284c7954048994c4f27862b17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "303a2c5ed897f8db92f2e38d8af78a292b99a400676bda8982e4a3bf4e98be8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b2dbdbae46d57c2aec02eb5c2966b772b9c3bb195faada94f0c5437b8f79c8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdboring"

    generate_completions_from_executable(bin"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}boring version")

    (testpath".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    begin
      output_log = testpath"output.log"
      pid = spawn bin"boring", "list", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "dev   9000   ->  localhost:9000  dev-server", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end