class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://ghfast.top/https://github.com/algolia/cli/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "0b7477c554c006de12fa936c9256c76361b3edd2a402b9be912efa61c4a1d400"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0f3a3ee93da672db9f429d351d7b381fb2c98bb74295b5864d1643dc0ff8d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f3a3ee93da672db9f429d351d7b381fb2c98bb74295b5864d1643dc0ff8d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f3a3ee93da672db9f429d351d7b381fb2c98bb74295b5864d1643dc0ff8d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "33bc87b6f7e7dfde2836eb978aed59c75a39435c08c3e856fd9cf20d3c98e452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad2a24e5c775fb35f0daca856acdd25f71ba63c1dccbb20a82e8f53592a594cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5afdc37907f966a114f326de3ccd49a29f1a7d1c0344fc889e695ede5f20411e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end