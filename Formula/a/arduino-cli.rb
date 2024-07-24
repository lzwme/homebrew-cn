class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https:github.comarduinoarduino-cli"
  url "https:github.comarduinoarduino-cliarchiverefstagsv1.0.3.tar.gz"
  sha256 "5987889e3a2675a8aca6488026826147dc82a5573ab61ed187cab40f4b6f433b"
  license "GPL-3.0-only"
  head "https:github.comarduinoarduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf36dd3af19dcbfdf60b163d98f00e641c03b7a1c86dd79cf087626f7c95f5dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be376fe141c43ad01208474e9f031eb11cf13ee7411920d4dea235cf064d7782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b78a4f0c499632899c943cbd6b5b860e4a093dd48d1b90fcd8a71f6622bc57"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f894aa9830118525955783ff7e468551f065774ad4b2bc043ea494cb4873f03"
    sha256 cellar: :any_skip_relocation, ventura:        "97c40da4a5d1dd7b398abf0d6fff762c2d0fed4bd812905818e08344d15cc266"
    sha256 cellar: :any_skip_relocation, monterey:       "604dea249f8aa2e756e4d708d0926fbb6bdd17ea817993d3269f79a8ab37c4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb61a6f8ec123db22c40e89e9df253033065a4cb3aadf1c4234b82773ebb1ab3"
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