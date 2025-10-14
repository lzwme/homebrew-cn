class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://ghfast.top/https://github.com/konstructio/kubefirst/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "e0f5963e4303b2612298cdcc0e31012ca7ee17d95316041fc77bc372881a8d98"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9251d605b79770a71678663f223dbf819e3571b79c430602e8bebe7c45bd5373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce1bf579f53231e5268472b4e5780390013dabd78598bfdc96e6ef0551ea5f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20ab9809a62afe816d1f230d98fea12d30d2bbd0f7ec06c117eef5985237f26e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a535597b1e1fee23683affda08238fb83fb98897164ea51f95e78222ce8cbd7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9582d03eeedc7abde9ef6c02b43245b68c9fabc01f8ec71f63633f4a9ffcef27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2965a5d98e1ed31db29a2709d2f2e77c72291593e74fae98405a3c1fd7c901"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_path_exists testpath/".k1/logs"

    output = shell_output("#{bin}/kubefirst version 2>&1")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end