class Ots < Formula
  desc "Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https:ots.sniptt.com"
  url "https:github.comsniptt-officialotsarchiverefstagsv0.3.0.tar.gz"
  sha256 "2b627dfa22e3f92f3c70b2d4ecaf8a9a63ff8183b31e611dc1933cebb3b0ff22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f32ee5d1b1d48f0230e4a3173b1e6c48a932c094242b4698b4a1ac081199985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f32ee5d1b1d48f0230e4a3173b1e6c48a932c094242b4698b4a1ac081199985"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f32ee5d1b1d48f0230e4a3173b1e6c48a932c094242b4698b4a1ac081199985"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06a3654548e7f87b5f8296687914f62f98a6b39d4b6720e8bded704e986dc8c"
    sha256 cellar: :any_skip_relocation, ventura:       "c06a3654548e7f87b5f8296687914f62f98a6b39d4b6720e8bded704e986dc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "750f6852f5e1f3b84a9fe856280a13ed278efd9cd6477b23d7242c66686637cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsniptt-officialotsbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"ots", "completion")
  end

  test do
    output = shell_output("#{bin}ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end