class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.3.0.tar.gz"
  sha256 "ff39f6ef2b4ca2d7d766f2802520b023986a5d6dbcd59fba685a9e5bacf41993"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27e784f9c2df847b757910bdc6ea18eb4702e963a0d63065affe86b08503d195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "781f4a1865583cb83103409bd472cca92c50626a10ca43897e9e3c164ac679f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345c35812a2414898d35a38a44dc28bb862253da17367535371d6dfaca1b9cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab6e354ed3f6d71a1a3d88c840d907ad66b3fc18e5e48331417e9e79241e977f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593e3562755ffd9bdf81e5fc76aa7c40b9101c8a22a4417660715a600c5d416c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd73bd81b850894cfbaf9b27340fb9aabec4b9a5ee3ac7e1eab580a518885b7"
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