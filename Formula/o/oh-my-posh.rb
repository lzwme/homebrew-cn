class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv21.27.0.tar.gz"
  sha256 "e92d40608aae5f38307740e21102493fc8d6b68fa83c0cef838c9811575cb885"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "532774e3e89933ae363aef4075dfd38ea27d3e4ffcb323cc2c6a21d74b7cd7bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f971ce184d776ddf331b0f63ef80be8ad345a9d3f6e36b975f162cadef1d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b576e28c00ab75d04dfa333f684a43b0b4db4e9d4d7dedc4f144c7161334ba3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "252ba2d4c2a47cf2f782901f9aab3c6ce22cccc7812bae09fb1304b5e324d9a1"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae8b272927834277f649f10e720b62e82de3c03ba8a510b943d9b63044dc3ec"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd723a94e72bbb1198f5bf3b5c8d80ff7cfd720a616f61e915086911174ff0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0acd3f6f165fe9f6194b0b4a3531911f70437ecfb0c373f29fa60a8b04b86fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end