class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.1.0.tar.gz"
  sha256 "c363b642bd1dba3a606992f9e8a0d7f2be50a6dc6ebc35c626dc54cf0906dbcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46fe0e0bb1ef9c6320ea1c94e9f5786f638d6b4828391bd2b8879f514569fdfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "616d0aab6a5574857faac845575bf87c01447c4be46da68560f286d931dccb23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a12d573091f7153b92882202385b189e5c6aefaac493ab8a99ff3f7e4684ad57"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e300ad18b17a9f0e59172c2f10e4c20ab82c22f7539c5ade739eb7d2331f600"
    sha256 cellar: :any_skip_relocation, ventura:        "9d0c9af1e7c0f901a2bf6e83609d43beb60f544de2045a725f8c9415896afc89"
    sha256 cellar: :any_skip_relocation, monterey:       "68e4f81fc0397feefac3819821e62087ddedcd833e189c879f236837301aaa1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782950a6e8cb95bab711c6afe18a51462c57a40c9be2339a55d2c41967846467"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end