class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://ghfast.top/https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6f13b191cae9310ac843bb7f605222c63c6972e7447852a6a74813883603eb9a"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e94428ca28595ee6ff4f924265b374b25b744118c1466320347d86328988b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04e94428ca28595ee6ff4f924265b374b25b744118c1466320347d86328988b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04e94428ca28595ee6ff4f924265b374b25b744118c1466320347d86328988b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "751e5354aaff0eb436858d7cd45ac78597949429a21737b856bbfea2a83bbe3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dba7f711e2b5ea3e51515751ba81f4935c55bc2b725d32976040bc61c6cae44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138ebff62bd21f6bb696013a7372245c7c1e701c0b28d73b3d0050c2bc2bb066"
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