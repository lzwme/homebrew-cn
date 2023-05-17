class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.10.1",
      revision: "74fe2055915f7bf04cd6ccdec649fab9c4567450"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86ba230f607f354cf523b715ef79ac6dacecba2ed8d18099409c1b3d02a54f05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ba230f607f354cf523b715ef79ac6dacecba2ed8d18099409c1b3d02a54f05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86ba230f607f354cf523b715ef79ac6dacecba2ed8d18099409c1b3d02a54f05"
    sha256 cellar: :any_skip_relocation, ventura:        "606cff48d1012ca2708ca414d18e6785c56dfed1809cfcc37e92166c75b2945a"
    sha256 cellar: :any_skip_relocation, monterey:       "606cff48d1012ca2708ca414d18e6785c56dfed1809cfcc37e92166c75b2945a"
    sha256 cellar: :any_skip_relocation, big_sur:        "606cff48d1012ca2708ca414d18e6785c56dfed1809cfcc37e92166c75b2945a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf53c378b062b708e0007941de7063fd55ac2be70eb3da03e2114b14bb7b2bab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end