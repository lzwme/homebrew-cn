class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://ghfast.top/https://github.com/j178/leetgo/archive/refs/tags/v1.4.16.tar.gz"
  sha256 "56d733633e0632469f71d6d43893d7698bb768403f498511f01b3ef2b6108d3f"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23772f85b019322c7ca508276268b094936645870f69ea54256c2da2cfc6fc57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dbeb67df8b3b6863748c5a94ffb4226f5be5a9401fed0965d8863f5791fbe61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004164182997d78c68390630a1a4f2d1821825ee864bf80a6940db0523042b87"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c33d4d0626b9cd8fb4ba420f4f4ba74565bf57a522009a913ca380a2f29306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1fa2a52522a42054b7b0d5eb910f827c76dad25541f0e04f6b9c4355ffb012f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e943cf6ddf3f22d03f12dafe91a868df569a2ed33e78b77a939a0986097ad2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", "completion")
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init"
    assert_path_exists testpath/"leetgo.yaml"
  end
end