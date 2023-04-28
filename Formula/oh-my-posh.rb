class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.4.0.tar.gz"
  sha256 "5458a49f9e949876c56a4a9daf735679c51f8735df22ad0e472fa797678a3f54"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bf00215b589e1ba1c628ce56776e1a6df163152244380e7c86f38077b8c06fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b54d353424cca05e99ea1719f073ec3b8c38c8dfeebcc4ebd624b6c6e5618f9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5dffc487b25fc2fe0737cdceffa14b91f7a2714847252771ea18fbb28cbd63a"
    sha256 cellar: :any_skip_relocation, ventura:        "0dd209d78f6987cdef2c00c2cf319ea275baf90b1a9e062909e560b7d42b1277"
    sha256 cellar: :any_skip_relocation, monterey:       "9b299af81b04f3e82b5935244eea0ac10920424506c174fde0fbc49132eaa8ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "57bff814a39d98cb70b3cf240a78bdf39ba312d3ac1662bffceb97fc903aecf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fcaa3c180adae61b405c693a074526fca46d0731fc59ef8f76db3f4fc9bd13d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end