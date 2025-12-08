class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://regclient.org/"
  url "https://ghfast.top/https://github.com/regclient/regclient/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "e4e5a420d41feeb6e9cd1d2bd41d6d1935e37c17c880737aefe3f67ac48f3583"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e24b9b2c5c67d01c66b3c27104b7827d81ea7126376c41144a55b4e142b8d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e24b9b2c5c67d01c66b3c27104b7827d81ea7126376c41144a55b4e142b8d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e24b9b2c5c67d01c66b3c27104b7827d81ea7126376c41144a55b4e142b8d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "05d72dff6b1b9a783339544dca1df04ca071177aab997884453138d9916e9562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd4f70a427189356083f37a3608424a69ffcc17391ceb21d260ec31a38316121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b8b1bf940c943773f1cebf05d435c6d3e62743ea49713e86557c0cd7f2d21c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "docker.io/library/alpine:latest", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end