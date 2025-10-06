class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.1.0.tar.gz"
  sha256 "0c2649e509863000713753b0376304e67ce52541aa15c6499135160174cbb165"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5311e78b27a0c7c5f5e8ba67f3f19a90e82b5ffdd23b6d00bc9a160ecf7a5fb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad4fca1ff63b14cd361cfb8dac7bfd3c79570b485a1ac2e1a023750a276ed335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19fc223573046a1924f3e55082a437fc76156ce7bc3ae3c3cd36921256f80c59"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a1dacc0b83654896f2f8f4a034baa7828c9e8e4deb7f7f9b197009cdb12a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8a07e4b8d2e641bc8daaf68c5ede294c57ca35bde6d490f63a30d0eac7feea"
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