class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48773",
      revision: "2407ffd60a3c81b31f89e54ce7e6257ece2ce7d8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "badda99c65ce1d5459025ceb65d58b9520d4be191a2bcfab3847564951bc1c52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd8ff48cc125619162d61135963b7010af4d02c2a87fe58fd3b602d8f383c086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc01e033856e6afe4f3803abbcf96acd876bb20d0bbbf3c9f296ccdffa753269"
    sha256 cellar: :any_skip_relocation, sonoma:        "2429fea6aefcefc4a644bd57bc190dd99eab74148fa3765590fa6332aa2d036b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7791590a1b2bb06db1071ab337e9455897f57f5fee9611cc8ca549e0b741172"
    sha256 cellar: :any,                 x86_64_linux:  "24bbe59edf58164e601e51f0733b267cf2208f7a8b3767eb941dbe5eb4f889ba"
  end

  depends_on "go" => :build

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