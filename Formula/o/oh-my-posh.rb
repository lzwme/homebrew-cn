class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.16.0.tar.gz"
  sha256 "ce68a960e968bc84b81192447edc5596c14c8b177eedcd9f9c5960a5543505fe"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "818d03ffb83d1a8b0bca24bef8f463d704ab78f0ed70f6b8aa0ad57ad611d887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d159a22907ddb7bb9b61b62eee0602ea3afb0fc3d89d75f9a81e336df7d03d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d095f0008f4087a44e1adcb40ee59822b78ccff4931b11b85683a502e7018e77"
    sha256 cellar: :any_skip_relocation, sonoma:        "451c8c84a1c3a73474a945260816080f4694ed2745f6e42ad5e5430bccc86463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37fb8554c68e4edabd1d6538ae1a05c36a1dc74bdf3b61aef5e64787b8d7579"
    sha256 cellar: :any,                 x86_64_linux:  "96bba540f40202d3d565668f79198d393df95688636fd5a27a6abd8e65cf81b6"
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