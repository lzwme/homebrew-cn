class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://ghfast.top/https://github.com/konstructio/kubefirst/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "8db06101bacdfa5710acc1b11f94385c9e68e62b5217f1873182a6ed65876b82"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a50a86602d2110bbda279b69fa7823e17b508a6086297f75c63b0ec5f52b452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eddff6dc4a0c0b676d29a050eeb66f4e335ff6ec73f4108c864ab5aef753f98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24edec6b8ca168f369bd9474bc677b5f6c9f7c7a6109948e26cec1549573c869"
    sha256 cellar: :any_skip_relocation, sonoma:        "408201e44ecd45b974e474f48fddb8c167fc2f4023d5268cbaa759921f40b21a"
    sha256 cellar: :any_skip_relocation, ventura:       "04e02ef5b6ea9f2b193d175a51623f5dee7b1428485a0b5bb73a59a4613473da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70dd1173668eeea00986118437ac94ea8d07c8adb56e41c683eb0c61f649d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348506b9333931f71d6537a95ad9caed0a2215ae8f4fa234b581004094649afa"
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