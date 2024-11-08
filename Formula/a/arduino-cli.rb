class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https:github.comarduinoarduino-cli"
  url "https:github.comarduinoarduino-cliarchiverefstagsv1.1.0.tar.gz"
  sha256 "35681850bed6af2379d1cd40cfda6064ee24e4933eeb1cfc1df47d5b0f8ed70f"
  license "GPL-3.0-only"
  head "https:github.comarduinoarduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edcf278ad5654a6af1183f3ff66d18c9bc054dcbbb24ed7b9063545157f5df71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ae7e979ed9d0804ca30d2af1794586499f8fa2c07a7e5889c174f4e2d321e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "577921ac79c22438e1b74f5b555478f4a3e23401a2d8dc7ab933a57f31d1c1ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e6d8bbd30040d58f69cc5c359e1ea089ae05c8d32efc2c038836d3268e39361"
    sha256 cellar: :any_skip_relocation, ventura:       "c42d033793a374f3b627d56af5f23b97dd83c05a5414450ae3768602bd4005e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ce7f1819876915bcdc38784f8dc8dafa5b7805c10b1ff696b2630e11b94490"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comarduinoarduino-cliversion.versionString=#{version}
      -X github.comarduinoarduino-cliversion.commit=#{tap.user}
      -X github.comarduinoarduino-cliversion.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"arduino-cli", "completion")
  end

  test do
    system bin"arduino-cli", "sketch", "new", "test_sketch"
    assert_predicate testpath"test_sketchtest_sketch.ino", :exist?

    assert_match version.to_s, shell_output("#{bin}arduino-cli version")
  end
end