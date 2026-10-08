class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.3.0",
      revision: "9b7fdf89d81c5b30a92ad0c61a2fe19fc7db2117"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44c542a9b15e798934df26348dd29e3c0cbd3d59baf61c16a4d0551e49159d70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39082713ff25cedca8e820db3cab3710d1b420b16e1b6bec3dd57f5cd6f4a95a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f61483e507652d0262bd7787d39abdeefeea495bd1ae6ac991a3673765253c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3bde3f7e168d9dc45fbaa2387c96eb3b0dddeae6a4fab53e8c6c35c49d44e72"
    sha256 cellar: :any,                 x86_64_linux:      "e7994e93ff940e588ac81c2a9931edee8d9ad56f444b92f38a8d715fd6591eca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end