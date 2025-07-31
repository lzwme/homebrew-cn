class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.17.3.tar.gz"
  sha256 "7b7ba17d886974e2cf335a9cebeb625151f7394d0fb981717ec67b45b982dc86"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e6f01b11926e2d31c333ca6b55cbf31565c9d1354256d53ba622409f8df697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7678c9b65ec25a46caf84c110138e1ab91d627c04f60622de55e1cef2b60eac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d36f09abfa67978254f37e054942458222027a1eeb629b36b6f0a64ba3123a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cb11ff079afa8fa82dee16c9903c8902bba8becd1bf9f311f3b77832db2228f"
    sha256 cellar: :any_skip_relocation, ventura:       "ef663b26274080e1fa3f08d80b633d581efc36fbd7db8b718da0f250724981ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "876f538feb0da770ac12e85d75b18d7f4c2bafeca875e99a9f53dc40edb0a86d"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end