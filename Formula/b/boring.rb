class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.10.1.tar.gz"
  sha256 "a1b15a4a0959593d3942eeffcf111e84faf92dcf15b6bc2d88599b3eb050ff8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c6f0effb6d7fede7931b1c717fa44a709733dad132f996d7752cc59a28c9ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c6f0effb6d7fede7931b1c717fa44a709733dad132f996d7752cc59a28c9ba7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c6f0effb6d7fede7931b1c717fa44a709733dad132f996d7752cc59a28c9ba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "634dead5c6826267c35e2d0e87dce53c33ca955cb315c78a7046240cb4f84fac"
    sha256 cellar: :any_skip_relocation, ventura:       "634dead5c6826267c35e2d0e87dce53c33ca955cb315c78a7046240cb4f84fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e608145ce638a2409bd71dfad99dc435530c76492e3aceac4ecb585d93035d8a"
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