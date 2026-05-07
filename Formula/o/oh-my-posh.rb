class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.13.0.tar.gz"
  sha256 "33515c031167a40c65474a10bbe4121e13b26749d7dec7a9c7f8d420d6ba7bc2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbb44c40bb2e37144d1b762718b29b76c3b618b815288f2a0aece84905fbb37f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af9335f75d52550a588cb62e4cb6ddd5d05d3a866da7b30d7e074733f58ec097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36e23630c72ea4c428fa1d2ac0e1eb1f1c69771e851b9060a6d8b33de020915"
    sha256 cellar: :any_skip_relocation, sonoma:        "60f3073b04ac51f4b073a53250ac620f205c18223a1f2da54630cc1c83f8c6fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1432c330a94dfa4af461fa398b15e91b12a9dfa83f3d1f2b9fd439a35f84fd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17061f8f2a56ca246d2fb11044e5955a658808b8c3f3a8c75e9ed0038dc4daec"
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