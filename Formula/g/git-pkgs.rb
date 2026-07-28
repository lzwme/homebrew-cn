class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://ghfast.top/https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "2180068ae055f8a670f09360e02d19e14120eeeeafc98a94e936dae7706ce2c1"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25c8c5a489f07f15f7365379f22eb6938e78c8976353ef89ff2eb27c0ebc2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25c8c5a489f07f15f7365379f22eb6938e78c8976353ef89ff2eb27c0ebc2b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25c8c5a489f07f15f7365379f22eb6938e78c8976353ef89ff2eb27c0ebc2b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9e1e306f90ff2155cb53437759ac30860c9c4e69d98f37e9ac6bbda48f3dd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47a02425bfd0434b9b66781050aed6c2dd73261d3b374273953389f98a9f902d"
    sha256 cellar: :any,                 x86_64_linux:  "820134c29e56b1ac741daccb0c314814b0c008d7bf4688ae17b4b6f423827df8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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