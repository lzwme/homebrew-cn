class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.25.1.tar.gz"
  sha256 "2d538ed715ea11e021b747af5376aa0be3a4f88a24b6ac0a6c315c5f8a282741"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9d83b2e4a4c428b3c2062739b3d7012f67637555238e0820d3d0f044082da5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5c9d14c8196ddef830bbde21062b3c4bc236208a48cb79838c5b174f0a22e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c621f1b29acf85a3266dad957972f59668be40a4f8cb5cd40128f28a409f1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f858def675822eccef044149aaa08ab989d3eb8c01a157598bd2946daeeced20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a1f1d2f78d03e1cab6a38136884090b78b0327cf0a2c34237afe501ce428fd4"
    sha256 cellar: :any,                 x86_64_linux:  "dccfe3424e3275091b3dce310a09b3f78b8ea83109227e2ea14ec22052225ff3"
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