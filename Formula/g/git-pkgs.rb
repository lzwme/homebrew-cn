class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://ghfast.top/https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "1d7941470e80f6a416431d62cb10d3f6cb50df53d57e782806990457baac1c6e"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b976840e32bf9bdd1e422466ca8db424e57ae995c64f2849c2fc50cc0864f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b976840e32bf9bdd1e422466ca8db424e57ae995c64f2849c2fc50cc0864f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b976840e32bf9bdd1e422466ca8db424e57ae995c64f2849c2fc50cc0864f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "304cde83b541f4c72e5ea09970a37df25adac0dbc7467d0fb366d62cdb9b0b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31da5b556197b40124e8bc98ca82acfb8248a6c93153ff0b3f78b20412dd8902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf7d4ab3a5f55775441c1f0ad7f1e98b801b4eedf1e272173d4d042dc787c1f"
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