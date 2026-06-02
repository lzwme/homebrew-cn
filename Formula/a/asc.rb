class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.9.0.tar.gz"
  sha256 "87ade1af1755a054e8871036c39e85de8365b2a7efa8dfacf6026740786f8066"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "847559a327f6febd6f99ec296462de999dd644368ff46067fd1145077e6cb3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572774a65b92558f4438e81c2e41ebbb744da1472c8d3ea60209c3e347381a4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45c23103be1498f5944d99ee8eeaeb04389f84c039932a0e49ea1e66eb77a68c"
    sha256 cellar: :any_skip_relocation, sonoma:        "713a4d6b169790c009dedf65472f38f5cdda9c1ae3c318de95d0723487c227d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "589426cfc935952093f7b0d6efed4f21a2ce33ac21444d6a3dd6201a36a4f835"
    sha256 cellar: :any,                 x86_64_linux:  "98791a4728428f02d3d634047053b006fe5a49f844ccf6cd6807cf5a0fdf78b1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end