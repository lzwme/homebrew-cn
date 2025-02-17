class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https:github.comalebeckboring"
  url "https:github.comalebeckboringarchiverefstags0.11.1.tar.gz"
  sha256 "fcdb1fb10ebdc8dbf7fcb2740fe82d2211eab4283e4c2fe6ee66bdb7e37d1aa0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310e8fcb2954f86f10518d7aec6c6531923fc280f77bf33305adaf26c96051bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310e8fcb2954f86f10518d7aec6c6531923fc280f77bf33305adaf26c96051bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "310e8fcb2954f86f10518d7aec6c6531923fc280f77bf33305adaf26c96051bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b0ec22e13e0be7eb43b325522b9ce0a2bee49e8988b69d7dd3aeb053c740a1"
    sha256 cellar: :any_skip_relocation, ventura:       "b0b0ec22e13e0be7eb43b325522b9ce0a2bee49e8988b69d7dd3aeb053c740a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e22e4959d458801915705fe8e9608a20a0e3c9af7028f06a2406648311fc16"
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