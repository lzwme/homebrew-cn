class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://ghfast.top/https://github.com/welovemedia/ffmate/archive/refs/tags/2.0.2.tar.gz"
  sha256 "b9293ae653e99f0ba5a727b52541797bfb8cbafe5cac13187b5f92d2a9a4cba6"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "020e65c7c6f48399f1c8b6ccfefdd541eec62875e39c736ad7510b552981bdcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "042053b0942ff094f96ef8c5d53bc95a5061881bc86fb7aeb972691393495c51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcabcb53e0d2de0be48554448e0bc7a75904774866b2d7d4b8500d548efa13a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7be0e4ccdb46dbeb94df64664e8b62c0b29d0ecf43804cd78043d7909d793e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64fe3d02333b790d04b817382562407a50d8fcf04f576bfaebbb277de5447045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6093004bb25fc8902c5d76f3e45131db0267a72928f4768e74160e8ab77a9a50"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ffmate", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    require "json"

    port = free_port

    database = testpath/".ffmate/data.sqlite"
    (testpath/".ffmate").mkpath

    args = %W[
      server
      --port #{port}
      --database #{database}
      --no-ui
    ]

    preset = JSON.generate({
      name:        "Test Preset",
      command:     "-i ${INPUT_FILE} -c:v libx264 ${OUTPUT_FILE}",
      description: "Test preset for Homebrew",
      outputFile:  "test.mp4",
    })

    api = "http://localhost:#{port}/api/v1"
    pid = spawn bin/"ffmate", *args

    begin
      sleep 2

      assert_match version.to_s, shell_output("curl -s #{api}/version")
      output = shell_output("curl -s -X POST #{api}/presets -H 'Content-Type: application/json' -d '#{preset}'")
      assert_match "uuid", output
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
    ensure
      Process.kill "TERM", pid
    end
  end
end