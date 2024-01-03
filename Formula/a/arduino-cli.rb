class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https:github.comarduinoarduino-cli"
  url "https:github.comarduinoarduino-cli.git",
      tag:      "v0.35.0",
      revision: "ebab482d737e9d5cd17e019272073e9477e2e4d4"
  license "GPL-3.0-only"
  head "https:github.comarduinoarduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f2814b8f5506a189c64e7053ea0b3877436c312bed9508f9397fb1985c0f8fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5064f05e32e3f5a6b90aec76ef787e67b5e82162d546f51fe89cee9d3650a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb7eb6d1d384e6ba02860a26cdeec9f8017615698ab00537854f6e0a793f17fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c519a628aaa2d52b8543d176f31b6ded4a82bca5ed572b1ae19feb58fbaf4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "8d306e57c696bf8e36beb30742f685e8df1b443979b079cb5b947b7dd7157453"
    sha256 cellar: :any_skip_relocation, monterey:       "ca053465b1fe176f12ea1e87eb91fb638b2837b6a4f7658133fbbc18ea85cd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8611f2a3d8fc208025536601e87e8667ae7d2546b4616b7df132f8784da8c6e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comarduinoarduino-cliversion.versionString=#{version}
      -X github.comarduinoarduino-cliversion.commit=#{Utils.git_head(length: 8)}
      -X github.comarduinoarduino-cliversion.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"arduino-cli", "completion")
  end

  test do
    system "#{bin}arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}test_sketch")

    version_output = shell_output("#{bin}arduino-cli version 2>&1")
    assert_match("arduino-cli  Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match([a-f0-9]{8}, version_output)
    assert_match("Date: ", version_output)
    assert_match(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z, version_output)
  end
end