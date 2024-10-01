class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv23.15.2.tar.gz"
  sha256 "2981a399832a6ba56b6cc66c86e6b4e3ceae8e088b97df1443cba48b952ade70"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e579911ea512ec33a23e0d0da0e6af0bffa83075ddf2fce11353cdcdc8e48b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4ba26830fce4b4f3993810a82dd4f7efb398e226ea1acf082d44d18ff6b43f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "833b920a447e9783e82883d7b4443e1c6808c6aa82a6a5c31be4d17f89940724"
    sha256 cellar: :any_skip_relocation, sonoma:        "40758893964e502d86011f46ec5f738fbf63d365ffd7a1cf8fa75e4ed4dc5d4b"
    sha256 cellar: :any_skip_relocation, ventura:       "59f89259d6b7c6076ab101a9b57170e8d8a2ae4a7c02b93cb9e31e7b7efc5196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659505e95954391089c7ed34ded3e2e9ca8b02e3cab9ac5d4f6709ff79799cda"
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
    assert_match "oh-my-posh", shell_output("#{bin}oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh --version")
  end
end