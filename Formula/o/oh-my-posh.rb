class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv26.12.0.tar.gz"
  sha256 "8c30c99779b7ea51c7b475ed4d01326922fe3b2ebea6afd6c212251565df8f23"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b1de50111ce7bab90d7a0b27b525c758d2d26468b867926a0804a0e2acd5bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f8f36b640dbfa4040fea71344a722fe0181fd9a0143521a7184e48e57bd9c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc7e5ea7f2ec0f8b973b4ccd2fe65c9fb969fb9dac30d778ea8e1e46ba0941a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb405755c93a5571000760a75e9e09e3a39b41107c26e89e0ddc1438915532c"
    sha256 cellar: :any_skip_relocation, ventura:       "52c2c9920c6f21e2a3e0abfcbc67b8a147f85309a9f5c475e0d08e55593bc990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5405c59b93a0708c6267f31d9084c561764550aab843cfcaac0833d4a2ed2180"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
    output = shell_output("#{bin}oh-my-posh init bash")
    assert_match(%r{.cacheoh-my-poshinit\.#{version}\.default\.\d+\.sh}, output)
  end
end