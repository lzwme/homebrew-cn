class Speech < Formula
  desc "On-device speech toolkit for Apple Silicon: ASR, TTS, VAD, diarization"
  homepage "https://soniqo.audio"
  url "https://ghfast.top/https://github.com/soniqo/speech-swift/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "7e244aa4945968728482b29aa0ebd1c793d9519820db8bd274ca7789f570ef59"
  license "Apache-2.0"
  head "https://github.com/soniqo/speech-swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d9914071b2b82d7ce4f87fd5a02a74e1aac8547c16074601b75703d38383fd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2c4b92ea00618d9d14915589fa3d664d481d79b189e8e091a258957e2942ee"
  end

  depends_on xcode: ["16.3", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    system "swift", "build", *std_swift_args
    system "./scripts/build_mlx_metallib.sh", "release"

    %w[speech speech-server].each do |name|
      libexec.install ".build/release/#{name}"
      bin.write_exec_script libexec/name
    end
    libexec.install ".build/release/mlx.metallib"
    libexec.install Dir[".build/release/*.bundle"]
  end

  test do
    assert_match "--model", shell_output("#{bin}/speech voice-chat --help")

    # Error path: nonexistent input triggers the audio-loading code path and
    # the binary exits non-zero with a CoreAudio error message.
    output = shell_output("#{bin}/speech transcribe /nonexistent.wav 2>&1", 1)
    assert_match "Error", output

    # Server-startup: `speech-server` binds on a port without preloading any
    # model and serves /health.
    port = free_port
    pid = spawn bin/"speech-server", "--host", "127.0.0.1", "--port", port.to_s

    sleep 15
    health = shell_output("curl -sf --max-time 5 http://127.0.0.1:#{port}/health")
    assert_match "ok", health
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end