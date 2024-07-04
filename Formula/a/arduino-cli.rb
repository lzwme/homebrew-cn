class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https:github.comarduinoarduino-cli"
  url "https:github.comarduinoarduino-cliarchiverefstagsv1.0.2.tar.gz"
  sha256 "3741dee1cf63eecd0b8b42f51c8e1570ceb464a38ff3acdbbeb214a88645d930"
  license "GPL-3.0-only"
  head "https:github.comarduinoarduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c23185dd7b39b3f0dd94551df70685bd994afeac2f5e596495d348d2a4b87cd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05d67cdd1413ece5e745bec1d64acd3bf69e3a344446bdad0ec9309a232157de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eb4b947c7267435197f324790754652922d8034d2ff0ec1dac7afef0906f195"
    sha256 cellar: :any_skip_relocation, sonoma:         "afa4d28dd10b32c3183753ee006a30df3272f725a8ba1d6ae23f7dceaec14c07"
    sha256 cellar: :any_skip_relocation, ventura:        "f3181071468d4c4120a7d30d74cba25b3422d9e40ad1ca0cfa862a55afc6728b"
    sha256 cellar: :any_skip_relocation, monterey:       "24d3123ed30c2f6e2e451d853187b27a4075f04bd946d92e0ab4c81a007c02be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328474a13115a3d70b0a0f8ca3b2f56059d4ca29630c86b669e180c1a2ed0d25"
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