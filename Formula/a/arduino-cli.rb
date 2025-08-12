class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://ghfast.top/https://github.com/arduino/arduino-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "26da84c51ba6ce9250374a9a38c9b145a89a528f6e818ca235e6e996eda68f8f"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61fee7cb397a2f14d4bda14bfa3c1fd7ef684790bd2202bab7ae6751983b59af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "053be33c1624c4a4b7f6a5f9d942faf0637a8d4a912c0eeeeaecc9e90434cc76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2dbaa30e2495a6e9236555eda5d7a4b5ce3f48d4d693330d0c5722a0a1674a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "71ccc332d2f8eca0f3a1dcada0c7c579e275728f2b646e1b28545fef725fa7b6"
    sha256 cellar: :any_skip_relocation, ventura:       "520b786b7882516960656efc1cb28c2ca3e5759ce042a6fb16f5a296144d4db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41018e8f90ab401db29f75bdc7735cd5af84c8b088fcbf7eccfbaa45529ddf2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/internal/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/internal/version.commit=#{tap.user}
      -X github.com/arduino/arduino-cli/internal/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"arduino-cli", "completion")
  end

  test do
    system bin/"arduino-cli", "sketch", "new", "test_sketch"
    assert_path_exists testpath/"test_sketch/test_sketch.ino"

    assert_match version.to_s, shell_output("#{bin}/arduino-cli version")
  end
end