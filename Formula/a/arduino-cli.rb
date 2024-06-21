class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https:github.comarduinoarduino-cli"
  url "https:github.comarduinoarduino-cli.git",
      tag:      "v1.0.1",
      revision: "590e73bf0412a30780298415180ee085e8d27a07"
  license "GPL-3.0-only"
  head "https:github.comarduinoarduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d898a3bbcf8e99fc7787bf4e532e9eca1dfb0df0bd99528c075e53c398524627"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0f61face6b6440a674dfa74fddddddcb175bc676b07076d92896185acfc395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87b43d662770b1175a93fa2ace49b769d982e6e9c808ce31cd2b121f4e382bf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d55504841fb9eea5af21595c50eb8fc9a61db491da2c3244731f6333ebe2b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "92adc8fcb027ecbcea8bc6f1f81a4d9c85470c107fc421150d0c79e055f4a3f9"
    sha256 cellar: :any_skip_relocation, monterey:       "0fdfa74bb88a4fc164e253d9d347d973e201076b3b337a7f6d2d2a35ffaa6bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a310d223fc708cd7b61a93b2f0fb749910b21609fe8e5901c9ffa42fb133a2e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comarduinoarduino-cliversion.versionString=#{version}
      -X github.comarduinoarduino-cliversion.commit=#{Utils.git_head(length: 8)}
      -X github.comarduinoarduino-cliversion.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

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