class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https:pressly.github.iogoose"
  url "https:github.compresslygoosearchiverefstagsv3.23.1.tar.gz"
  sha256 "0db063acea1ebc6fd205159028dab8bcdcb731e82fdeb4c6d4b2383783a16edf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bddcda0ab00022cb078a0239eabf68e8f2f9b61159735c93bd4437df6ed1f785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43dd3f90289acd0cbb0ab834ffe6a99d736ae9bf8b4a4b8d7c84a56ce4119f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "851964719de14d74d2a93bcaaaf879950767eca78e5a2aa04cd378de0730cf9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b16101a90955edd4537abbdaa6d32211af0216fa4db7776309c0cfb2f645e35"
    sha256 cellar: :any_skip_relocation, ventura:       "2137c2db4ace15519b0614022134425549f4287bde108547a93bcd0cb634fada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b09cfbcf279f98622c90138d2860756bea2cf13ea2bccf3b726c67f5945c1f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), ".cmdgoose"
  end

  test do
    output = shell_output("#{bin}goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}goose --version")
  end
end