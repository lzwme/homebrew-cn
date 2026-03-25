class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.9.2.tar.gz"
  sha256 "9201047b5ef32cf91cc70bafd28cb15f5c41bcace3fde08ef7b24c2ba45b5ff8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0aa1de245a8b5733a55d712d71d82bd002303c0ef8392c7160cfd83fa5494a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d362fcc4db1363c0b301343074053ff4e151108a0ed56136a350d19d38d08d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "720ead965cc76b0a926b62ed5cce7a1ae3c606b9a90fd6cc62a672960ed2f510"
    sha256 cellar: :any_skip_relocation, sonoma:        "f045f46a435a7e5ea41300c2aa2a7f6f466762426f9dbcd87584294f3a1cf327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d08d116e87e57f0f0fa734490617398e6efa747c65298ed58883a81cf23d687b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a60f4e7d3141d184f8621137d71c84893ad92e0f8123538924d0e7b0350a1a"
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