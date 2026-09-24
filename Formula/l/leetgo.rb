class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://ghfast.top/https://github.com/j178/leetgo/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "74811881a19f44a351030b7b84044bef25ebfb115153cab17495d8a211acfa44"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02f4605e8ce1532641c01abc47a8543638d71e49126f549809a203d8fcb3cb2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0b8bc42243d251ff124ea60181dd241d2371cbc56603834d56f7da3c18b6d43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f952678ad402b5740620a93cba0d2e2c6045a77eb941c4eaee690ce91a061b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4fe9c6d165c455957b6dbc3356fadd562dd303662c58ac363ba2d70998bcdf74"
    sha256 cellar: :any,                 x86_64_linux:      "52eace4eed93344bf7676c6169004adc349b7ed5861a1613559043cace9af783"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", shell_parameter_format: :cobra)
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init", "--site", "us"
    assert_path_exists testpath/"leetgo.yaml"
  end
end