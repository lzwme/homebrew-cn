class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.0.0.tar.gz"
  sha256 "369f3eeefd938c96cd46991ec985812ed9f1198624ee01b562ce962835d27572"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dd21ae606b567a66cbda12171c3444e47aa9225e7239b6882af98fde92f18ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2713192b9d0c1a9a2c5deb4e69ca389faadc41497405848d80577c0f8746a4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256ee803f10de84f874436bbd916237a1b28a715cd21df9bd7b84d24fde324ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "16814858059ca102c26c4afb260913633b6c220fb48512c67664e8509810aa1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef8eccf4b8031282e818d59e95aff30963f2b01afb862ee4a3ce99eaa69438b6"
    sha256 cellar: :any,                 x86_64_linux:  "0b8bbb9af48a64f131a3b6e32d974c35137f7439e46b45a1f06e43a4634828c9"
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