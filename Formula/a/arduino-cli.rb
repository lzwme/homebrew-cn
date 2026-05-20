class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://arduino.github.io/arduino-cli/latest/"
  url "https://ghfast.top/https://github.com/arduino/arduino-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "bfb3299c6afc6a40c89a55e7142e67e0b10267348bc225cc2e94589c28076302"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0412082f214b0ca17b363bda3c8bfc48ae9930b593cd017ea8656b1efe4024f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "245f24f8319eab3c53377f4fadaf0e655d50fbf8d21f8e0c4a2156d953530aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51ef0f177910c7f2599aee2153a302b3f828e60860e5c74659ca7acd6645da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9857cfcdc80833a47ca3ed80300c815e6b61185ed97fc17793106f2584801f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df0983da0cbc93240ca27e96918c887de60b16d9aa05302c07908a141814dc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf10ca57f43ea046dfe50c0a25c83ba5185a7dd57cd24f2e215864ed6709d361"
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

    generate_completions_from_executable(bin/"arduino-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"arduino-cli", "sketch", "new", "test_sketch"
    assert_path_exists testpath/"test_sketch/test_sketch.ino"

    assert_match version.to_s, shell_output("#{bin}/arduino-cli version")
  end
end