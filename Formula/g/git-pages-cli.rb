class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/archive/v1.7.0.tar.gz"
  sha256 "0ad3ce46b2a83930a704fbb6af710211da6300a640b7fd667997fb780dccf2c7"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f99047c72a81091195b41208910723be10264b03c52fcf3455cf1ced0da1fe69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99047c72a81091195b41208910723be10264b03c52fcf3455cf1ced0da1fe69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f99047c72a81091195b41208910723be10264b03c52fcf3455cf1ced0da1fe69"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c7b3aaba09b7e538715ffb8c127aa77079d7cb93f2022e92ce5696b59913568"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a64e9518ca11440936e83da7ec6f7f28b4ed17a257e89f90b6deef06aa681129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bea91b8ac8a673a197788066ab34009f85e4ff9917805f5d7bbb4190a322493"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionOverride=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end