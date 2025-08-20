class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "a20ebd67907bc94cacf3f5f5df3afab4c9f44c26fd85a20e07a399e99ad98bab"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81aa3f345dce6360258838df568e3114f4c3543b9786456523e981ef9e38e9e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8de59737218fcbdaff59145b0cecdfab50fb1833ddf9c437e08a23b44fdf4d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "235fedcdc4c97e17d6cba426d92745e9deeaf39fb3437dc9f3490e2a33a91eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd5f9f37b3509b6d274d7b8489c8979c9e4071da6004d17b5a4bf88cfa8b9c13"
    sha256 cellar: :any_skip_relocation, ventura:       "643d4244c1328499f2f2b441f40b938c27165e522ddcfaf270c9feaf42875ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f42e687c782678aacda36a7d4c1767f253ce7a3aa845dc68ab081c98113a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2893968509018b83fc242040d95a8cee6b989fb597d630275cca72c4a832dd0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end