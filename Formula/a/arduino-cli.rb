class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://ghfast.top/https://github.com/arduino/arduino-cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "142d48462387c0bcd900e7969892b974d26bcfa9e42674bf9e9c4da2919ca857"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a72f04aef01813435ee9cbca07c7d2d77a7d451e7befb690e083f31bd7f1b962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b947a38b69776a2afaa433f34df51a6f92544da9a34f7cb8403a17705dd1d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f960adf27555ab8019cc51bf60cd1aa362120892aa3934d389a84855730c7d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "61c3877965ae2940c164ea9935dad87556d156ba46674aacbefc85cc501137c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd00da57f9f0c6f3dfe9f120ee1bd03f77888ddb1f6f323f211cefd83178b037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d11a9dfedd0d0754ebc2a20f8a3f4a45e88d22ce40660d75313152e87c5434d"
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