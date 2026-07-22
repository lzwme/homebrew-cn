class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://ghfast.top/https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "13ce4e7319aa6899cf2849ebf317aa99cd1c5a5d770a20198156a2f1be3d9b60"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c63502a47ed298c4aedc97b4943a9f911185498c823ab18ab37a2e6d0d8a2f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63502a47ed298c4aedc97b4943a9f911185498c823ab18ab37a2e6d0d8a2f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63502a47ed298c4aedc97b4943a9f911185498c823ab18ab37a2e6d0d8a2f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "afd3ec28740e7cb831deceea103ae077d5f38846f4f324f019d341384a1a4c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74934a7cc1815b25c4bd7e287ce1948a773438c7555c6f65e4ffb6e71c27bc9a"
    sha256 cellar: :any,                 x86_64_linux:  "a817ab496423b702943e934e1b4c5ada3305daf21e563d6eb74d2697c0882c90"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-pkgs/git-pkgs/cmd.version=#{version}
      -X github.com/git-pkgs/git-pkgs/cmd.commit=HEAD
      -X github.com/git-pkgs/git-pkgs/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    system "go", "run", "scripts/generate-man/main.go"
    man1.install Dir["man/*.1"]

    generate_completions_from_executable(bin/"git-pkgs", "completion")
  end

  test do
    system "git", "init"
    File.write("package.json", '{"dependencies":{"lodash":"^4.17.21"}}')
    system bin/"git-pkgs", "diff-file", "package.json", "package.json"
    assert_match version.to_s, shell_output("#{bin/"git-pkgs"} --version")
  end
end