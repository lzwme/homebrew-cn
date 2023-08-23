class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.34.0",
      revision: "304d48cdf5a7fa49953522dd445f3ac547ee1aa5"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0d9e4d5a50b4d0a7e3d71a7d7531ca58d4a43e850127b6987b20a8dedfd230f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5c4c846fef97731b7f954a8cfd214cfcce8aa887b82ad624430709f274ae531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb6f98befe11d86fff63e50da351132d6f5d96939547f74e482f1c3e4e543e32"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f2ce78e140dd9213d941d84f84702313772a084e03603cd0a232ef0c46e3d2"
    sha256 cellar: :any_skip_relocation, monterey:       "16a15ebe4202e315e1b07e72ea0138b12696c6880744c631ca8cd71573180a0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfc32a964157e30c647bcf1939cef602e39e47b13c1f50e196bdf42f4eb6b441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f713d7a7f812d2f4dd0e3309aea8eef82e3076e9174600d7b4b8137dd265327e"
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