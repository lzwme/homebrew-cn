class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.14.tar.gz"
  sha256 "25ba1d9a405e3bae6588ba9dea09b6408c612339739ecefa17d2e8ebf9c644a5"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cfd787a9ab02faf124394487da5a094b6d26709fb2f8d2e171c995a2b889f48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a57f231163e798b2df6619ab884db963c910d45c2ff4734b68b377309ebf6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dffe715de382bca2f04476e96738c4eefe81951b2b5c54880a2d96631b942d3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e06cf72090fe2af21a8f9c91bcee202b00a2d9786eab2e12ee7bbef5a3e19e4"
    sha256 cellar: :any_skip_relocation, ventura:        "b2bbd14ca9f7b2e8e36aa1b9ab14c502c2b145da5cb331e279a3cea5c59b81d8"
    sha256 cellar: :any_skip_relocation, monterey:       "f0998190a4bd93b2a92ec6f2539dbf3206d89067b170c53359b17a5957eeb712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c15a711b7db7e7575445e425695b21f7ac7fcbd6102c86835c5cb43b921dcc4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end