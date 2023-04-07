class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.32.0",
      revision: "fe91ec6e87fd8a0d7c3889d49f697be74291d281"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59d67f9435069e703d80f9c6c68c5320bc3480a6fb75bb928a6fdc38ed1257a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de2fdfc63b119eef78a1189fc26272df068188ce5163135ce25b61612a24efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8d5adf49d08e1dd557fe05bf68b2f1d89fbd96c111169c9e2d1fe2470ed7bc5"
    sha256 cellar: :any_skip_relocation, ventura:        "b68ad3a60bebaa08357135adb6340f1026adf981073a1e765785e99810977dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "58ce98d25f46e8291d3051868cd231dfac085dccd169ff783ea25200d58f101b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d9c925328b7e79dc6d3a55858919a4b03634c7746e11f26896d0dbf4fe1c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8acd137b8641406af86dde0a32a38ccca38b38409b6843994aa9387734cffeab"
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