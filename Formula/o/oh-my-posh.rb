class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v28.0.0.tar.gz"
  sha256 "6e532fbf24703d26cc7f86e1405ce38a1ff958fa8688c184b90d4eabd4b6e6d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37a4385e14ef12c22c5ae07c1da59ad751a27d44de326e81644e9e6128c96798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "080d36ef538853153c8c1a02e761671dd39ea6ab71098cbfd28956b59b4468d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8e9e7cbe286663b634354911a319d49126e05cb2abb23576f897f23ffd9b78e"
    sha256 cellar: :any_skip_relocation, sonoma:        "569950c7a8c20990e399119f52c8d33b0fe3fcbb35df508c89c19957226d9cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9235ad7ae88d13c941ec486b525fb01cf15b15c32e9d2d66cf00eb19860f5a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7102976391e88d530f32e22c706a080e3e014a79627478b43118eb687c241a6"
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