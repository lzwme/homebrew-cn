class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.101.0.tar.gz"
  sha256 "7fae1357cff50f054616fed7cae6799718ce4f8c832881189ba318c0981cafee"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03438df379cfe3bc0bb327eb756666a87a4cf497d810465e8605a8914aee6637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0d8da71075159a2a82f3d8eb29decc0761f272f6493105e868cec4d4801318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c941822e9aff78d37f67304d641d8dd9e0dfeb48a59398f28c18ea98ae5eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe04e84c3ce84565866458963e3f58b76671e014279012aecdd0afac1e48beea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28489b04f03557a53e0c24b0f3b2fb42496eb7bef48335dfa9f6e9b58b4ec0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d207bc6df50e1c3a69f48c3828adbb485d5bf5fcf5bc36bf81b168cf0c204e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end