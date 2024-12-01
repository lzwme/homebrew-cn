class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv16.7.0.tar.gz"
  sha256 "2ef7f260d6443dfd46b208915984c507a1cf3c8723da2c51f2154f9c62669c9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc6a2800f5727ff6e299e67fc2c51c4bebbed3a8311cd44d927d55a41bbf6fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc6a2800f5727ff6e299e67fc2c51c4bebbed3a8311cd44d927d55a41bbf6fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffc6a2800f5727ff6e299e67fc2c51c4bebbed3a8311cd44d927d55a41bbf6fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d2a877451926ff11352d7ae7a30e4591a62b281b6880689ca58f8078a1187a6"
    sha256 cellar: :any_skip_relocation, ventura:       "3d2a877451926ff11352d7ae7a30e4591a62b281b6880689ca58f8078a1187a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad84f25ff056b17422cdf6a4550ce5e8b1e2021917120ed017579e860c9c4d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end