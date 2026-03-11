class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.8.0.tar.gz"
  sha256 "ffac245e9a5d2aa3545faee704159ea201ec35afbb27377ed11e12cac35fe3a2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86cda33c265c10715a49050ed8595d6399ff9952aa9b73068e64410f1dd238e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d5dead21dc29d0ece6501473a619382f51fa533f89af23cbbbf2243daa7d0a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9eb25692aa56cb16b1f5022423d051153c25bcd9d83c297de1f8734ec954a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddc01d1f81d1914e2871d3bc9cdc993b0047a6de6c2352d4043d82bf3f64ec46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09acc1653606301ff735ad738c7aa16fe29c6aef59da3bf804728f8a55e43be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a111d9b04a42243b8cc0a1aee41b1d6045e83cfcc198e9466b0b55057912927"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end