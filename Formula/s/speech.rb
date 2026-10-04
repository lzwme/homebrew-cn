class Speech < Formula
  desc "On-device speech toolkit for Apple Silicon: ASR, TTS, VAD, diarization"
  homepage "https://soniqo.audio"
  url "https://ghfast.top/https://github.com/soniqo/speech-swift/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "c3172d617383c1a595ee13dab66a418fdc7d6baac300c563e83da7ecd871d16d"
  license "Apache-2.0"
  head "https://github.com/soniqo/speech-swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2ced1a4885f7a70f93ee7380ef4f7a10e24eeb70454262fcfb3e275d0edf97d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c73be5c601632e62a1c204963b063606c2e6c8d19f2e714af54d28f7b0af5f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd78cb202a47a562d80970b2776b920c0f0f8604ca7c5b004625019bbfa73227"
  end

  depends_on xcode: ["16.3", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    # Workaround to build with newer metal until mlx-swift 0.32.x with
    # https://github.com/ml-explore/mlx-swift/commit/ab924c82ead3b970caaa1c0ac11171de23f0305a
    if OS.mac? && MacOS.version >= :golden_gate
      inreplace "Package.swift",
                '"https://github.com/ml-explore/mlx-swift", from: "0.30.0")',
                '"https://github.com/ml-explore/mlx-swift", revision: "ab924c82ead3b970caaa1c0ac11171de23f0305a")'
    end

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