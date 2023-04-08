class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.32.1",
      revision: "a8787b8275e9f87e46da8f5364c5577a6a757fd3"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af8956438f241dd83c6422dec108497041517f74166894871b59722a37c0d37a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf293cdfea3dfd39c0a75c81fe85b1653bb0d3755c79f4adb30c4705d55a0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a485ffc2484bb6df17666b87512c7a469a6565b7f85ef4a18a277c5e0e5bc116"
    sha256 cellar: :any_skip_relocation, ventura:        "cfdc0d462781d853fd32ae983159b96f581fd799151e2273b21eef0fca0c8e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3b54e34f69fcc31bf382ee07b5639b7fea273b9f3d6d1aa6549fb09ef94ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4076be38bf9e1e9308b2e6267cee00912cabcbb135a73199f777e74e0dab7d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98bf36d5d0653b25b679d198e1537f068c6494c9fd65b980c3b0e48e0daaa871"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"arduino-cli", "completion")
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match("arduino-cli  Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end