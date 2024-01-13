class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.5.6.tar.gz"
  sha256 "0c74c60fda887254e27f43be934c1177ecbf4c8d31b202dfb3f1719deffd6cbd"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c407d4b9e611be8ff4da4140972fe1d7bdf8f99ec81099ecc5177673e7e785a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ba734916fc26d31190420dd940256fb0e1c830d18a02ef804941ba6bf404e48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a5f1cb96a0b42d20b54957fda3ce703015943e4cb6c190d5c0475feb94ab0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b80e4c00c8c0cc12413c7a9a12bc63b05236a0590ab88f92470a06ed386ebf6f"
    sha256 cellar: :any_skip_relocation, ventura:        "ed3a331be0f28f929de3391f31277f0325cd735db209b209e72d9217a775682c"
    sha256 cellar: :any_skip_relocation, monterey:       "99b134fe454e9e3a25688e46b354697702e4d1edec1d725346e0c708a62228f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b14d050d13dd9067fd18b43845521d00114e776dd4bbeb14da79257b192d506"
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