class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.7.tar.gz"
  sha256 "8cb1770aa115ea59453727c38f1918647347ce9fd61dfe6b594ed6ca346f0361"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e409772c3c41116566cffc1c492de9224927cafad43cd82b3870ca1d953e3712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca117768a97316cf6a3ac4f3775f27dc3d7042e74680d1d99d6a753995cb85a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd18f635e2dd79c92cbbe66ec34cb409ca9b948472a3c086b4cd3184ffa6bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "368012a86aa9b92de28a0c1c9f2461832acec65720e1c4badc571286e1ddafd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179436f6738ad1f4e27f7df621097a23b38e85afe565e42d65382fa32049b3fc"
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