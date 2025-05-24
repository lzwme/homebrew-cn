class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https:kool.dev"
  url "https:github.comkool-devkoolarchiverefstags3.5.2.tar.gz"
  sha256 "b6a49d48ae596eb05aea46fce052744cc8cf10f21753f9224ba339d29a04e1e8"
  license "MIT"
  head "https:github.comkool-devkool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48a8e7d166938e43d4a68faf9912a34952934db3d665c297da9bf44069332a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48a8e7d166938e43d4a68faf9912a34952934db3d665c297da9bf44069332a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e48a8e7d166938e43d4a68faf9912a34952934db3d665c297da9bf44069332a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f6186319cf2b73fb9a455254286ca785af62b79caf32ff17e731ef49bec2677"
    sha256 cellar: :any_skip_relocation, ventura:       "0f6186319cf2b73fb9a455254286ca785af62b79caf32ff17e731ef49bec2677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68552d6fe32c2512b177459c9b04982c2f5a21c8b49eab5198a9a23899eaa67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-devkoolcommands.version=#{version}")

    generate_completions_from_executable(bin"kool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}kool status 2>&1", 1)
  end
end