class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://ghfast.top/https://github.com/konstructio/kubefirst/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "ecb063b07688ac41974b09b1cb0a3598e0602dab6fd3bdba8cdbba3fff459ed1"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c323c9caf96ddb0b76b3911cc8193f22ef401b92e5acafa5c545ce5bf7da111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2da1ec2c492b517eb47ab743b2dc0925afe3d9a0572414a2f12fe5f911043c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a84a65d1fd53d7989619b4c0b8089b5eb04997f960f4cad1f021bc030799f7b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ddb6bf5502eb3fcca876159de59278ca296fc648cffe0bf0bdc0987ac179f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e36ef8042d0833f142698806539ad4d182352306e2e2bee6abf4e5617bc40b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1491b9a76228bc1870699c7908d696e0b62ec151770d6fecad3b9456781783"
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