class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://ghfast.top/https://github.com/ko-build/ko/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "1006eb94b6260690ab3ec79cbd03342e09cb0f32cecdd1b8743fa216e2fe7b0e"
  license "Apache-2.0"
  head "https://github.com/ko-build/ko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e54454b25020d8bdc004f181d18d761f04d481797ef3ce83218163150dd94645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54454b25020d8bdc004f181d18d761f04d481797ef3ce83218163150dd94645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e54454b25020d8bdc004f181d18d761f04d481797ef3ce83218163150dd94645"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa6b805878951cedfd927effa63c5d6a7d3eab77d2fc4b83ee2457a97d2c3e01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f682c358146f90d7837f21be6e35e84b898ccfc2b1aa6daf74fd7cef31dbd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a57468841a390329cb0869bd0a4293a0882d053bfb1ac612b297b1e4ded319b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end