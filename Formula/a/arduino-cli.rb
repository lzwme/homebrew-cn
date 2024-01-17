class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https:github.comarduinoarduino-cli"
  url "https:github.comarduinoarduino-cli.git",
      tag:      "v0.35.1",
      revision: "5edfa984c5c21209937740ab5dd577fd8abf1d34"
  license "GPL-3.0-only"
  head "https:github.comarduinoarduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2203516ca8bf2e299f8380ab0ff8baaceb5f274976e7a5ccf737dbae85a53b1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c37e8a749a754b47966ee3c0320e9e60ebdd6ac32bec5a5083af84cae7fa16e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc518f11f60d74f09d645e67463c41e5b4237befabc76501a6df0fe41af1015"
    sha256 cellar: :any_skip_relocation, sonoma:         "2862beade09fa03e12133d0a76587abc9117baed973b8c572f4ec379418813d9"
    sha256 cellar: :any_skip_relocation, ventura:        "54454cb9a0c6690564d123d24892fb02aa0a728564f4f92631452650c05f95d8"
    sha256 cellar: :any_skip_relocation, monterey:       "57962a0d87fa69b7fc465a3755edfdbae6d4eddac3adb9b21416f42096a94a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7631a9f7ac6291873fc97040535480d3ad48a88a5672dc1ba1db5309cb78ba2"
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