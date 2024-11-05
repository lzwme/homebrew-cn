class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https:rhysd.github.ioactionlint"
  url "https:github.comrhysdactionlintarchiverefstagsv1.7.4.tar.gz"
  sha256 "3004bcb4615510e671c76a56259755ed616c3200fb73b0be0ca9c3d6ea09c73a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4800fafd738d38fd98e07e3c2ba1e46926f74f0a03f153eb40fdb639da44a910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4800fafd738d38fd98e07e3c2ba1e46926f74f0a03f153eb40fdb639da44a910"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4800fafd738d38fd98e07e3c2ba1e46926f74f0a03f153eb40fdb639da44a910"
    sha256 cellar: :any_skip_relocation, sonoma:        "213db714539ffe8befc312eeeefbc3f6f6169f3d110006e18be07b631d839291"
    sha256 cellar: :any_skip_relocation, ventura:       "213db714539ffe8befc312eeeefbc3f6f6169f3d110006e18be07b631d839291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c290ccc5d780a1dc747bd21e280b0021308f3d2f94a7c8a99ce7f3072e80d7"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.comrhysdactionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdactionlint"
    system "ronn", "manactionlint.1.ronn"
    man1.install "manactionlint.1"
  end

  test do
    (testpath"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actionscheckout@v4
    YAML

    output = shell_output("#{bin}actionlint #{testpath}action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end