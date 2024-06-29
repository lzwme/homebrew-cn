class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https:github.comTomWrightdasel"
  url "https:github.comTomWrightdaselarchiverefstagsv2.8.0.tar.gz"
  sha256 "906f2bdb7866c58d16b7b3643f9ec19455384a9a4a50e1bf6bf59cd3914076a7"
  license "MIT"
  head "https:github.comTomWrightdasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "357f82512a8457b31393795a78c2cdefa963de58b41a9f6a04741bdb1941927f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c851022fb9979e022705d6ff1f8848b84cf4a288b0e16b0c2493c9c1d2f7de3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d404ed63d28e2539a51a72aa706036cecb417c4f6e0520ee0db30209bad9318b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3af17a891d36606d4fee59c113fd1aa6cc3da76b344b78344d7c5f122a16adda"
    sha256 cellar: :any_skip_relocation, ventura:        "23de65cb5263d2e35d07d888735e13e7ecce1ef3ec9cb791ef2b7d1be50792a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ab545396e7d84bf12769058717b72975670e4ec81ca3ea5a14258627c906c8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30da1e69b2b71336b41f7b56c58b3d6826a59f9ab50858fa78e6eea86450622c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.comtomwrightdaselv2internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:), ".cmddasel"

    generate_completions_from_executable(bin"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}dasel --version")
  end
end