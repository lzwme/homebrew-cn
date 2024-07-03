class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https:doggo.mrkaran.dev"
  url "https:github.commr-karandoggoarchiverefstagsv1.0.3.tar.gz"
  sha256 "c97938dc2f98d24c1501951c5062b0f9a307c072822410ef3e10f149cb370c92"
  license "GPL-3.0-or-later"
  head "https:github.commr-karandoggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1d9d3ecf7acf5f188fc6cf884e5658ce31adb437378d45d37abe038cd413759"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1929071f5dedfce89caf5c52a2054a37bf9784120ccca2f7ee783c28b5dd22ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b9e42ac4cfcbe8f2ab40c17d59d16c42e51debd52d9f32895603702f74644c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2c49feba439434f1d056cd7cdd0aaa0a74f6f951c4f53fbcce5868f03d70c20"
    sha256 cellar: :any_skip_relocation, ventura:        "3decfe089806121d59f4f9a0d21257cbad82978d7770fd959230d2d0a13bd6c9"
    sha256 cellar: :any_skip_relocation, monterey:       "8368bfdf7df27d04e1234d34dff9210584013c64e6c85bcae5b5392e681df49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dfa0199f9ee9525458d440a8204d8d2bb5cfd1261fbd77d6955cb5c602e4117"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmddoggo"

    generate_completions_from_executable(bin"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}doggo --version")
  end
end