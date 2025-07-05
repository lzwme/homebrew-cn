class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.10.2",
      revision: "063c5d5b5c66fbdeaf5c50aeca444f5b581ec849"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58831d56af4ea603e0f8b872167734516f4bfddb4cf3d31d4ee418079cf5a612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58831d56af4ea603e0f8b872167734516f4bfddb4cf3d31d4ee418079cf5a612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58831d56af4ea603e0f8b872167734516f4bfddb4cf3d31d4ee418079cf5a612"
    sha256 cellar: :any_skip_relocation, sonoma:        "45faddc59352036449b64900d8d8170c68c58ebb56208b9972362449ea751295"
    sha256 cellar: :any_skip_relocation, ventura:       "598872b8403f42408ca27b83e797c26f90894b341048d6cd25611b937b72a0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eaac9950a8c375717f0df643fe5d4fc2e03ec7309172f52893f1b6c3b819155"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end