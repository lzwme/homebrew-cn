class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https:toitlang.org"
  url "https:github.comtoitlangjaguararchiverefstagsv1.50.2.tar.gz"
  sha256 "a41109c49a2eeb0cbaffa752353968194867506aee9476a1e8b46184e1ad5fd4"
  license "MIT"
  head "https:github.comtoitlangjaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "380c00f5e703891009915fa028897df8a028837a5a5bb75f74a5117355a0f1d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380c00f5e703891009915fa028897df8a028837a5a5bb75f74a5117355a0f1d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "380c00f5e703891009915fa028897df8a028837a5a5bb75f74a5117355a0f1d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ecd1b6716bcb2e541f6af04da9e0e1fccdd0550b4f3564efca5146364f986e4"
    sha256 cellar: :any_skip_relocation, ventura:       "5ecd1b6716bcb2e541f6af04da9e0e1fccdd0550b4f3564efca5146364f986e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98d49bf94d9c854550bc0f78d2f007acabf90f07deec70b65d4811fbe71c584"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"jag"), ".cmdjag"

    generate_completions_from_executable(bin"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output(bin"jag --no-analytics version 2>&1")

    (testpath"hello.toil").write <<~TOIL
      main:
        print "Hello, world!"
    TOIL

    # Cannot do anything without installing SDK to $HOME.cachejaguar
    assert_match "You must setup the SDK", shell_output(bin"jag run #{testpath}hello.toil 2>&1", 1)
  end
end