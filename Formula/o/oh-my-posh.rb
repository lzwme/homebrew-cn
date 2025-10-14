class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.2.0.tar.gz"
  sha256 "db4a58520846eaef93bb2db88eddb4e8f76c7ca17f42443a66926ddc872bbe09"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "650edde0c84145a5163ac2f5f3c03ace3211e221c8047ca48e0dc9b19a7f6478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032a9855aaf2f5836b6a1665b7b58f6a7ec5da113530b19eea72a85aeb707ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb95d4f892d937d0e105371299d3ea5c0de96e1648ed5d61ba9b20cac7b8e2f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "441dd013363e65dc38fdaf7038b5f7136b0f93bd6268fb78898d643299bf9b36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9377be19eee4cc51f55157e112c467858a8d0e6b100088729e5a747010bd6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10f53a1b134ff156589512a7defbe83f6d9e5db923b1c93a87a185e1061db7ae"
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