class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "489b8bbe863eb119b830ee0a9287ca835d1201379b885e4cb7353b5e59138d53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76685cf44e1ac8609a46051ab21b0a78ed9ceb4201c026743a5a38fee66c23cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76685cf44e1ac8609a46051ab21b0a78ed9ceb4201c026743a5a38fee66c23cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76685cf44e1ac8609a46051ab21b0a78ed9ceb4201c026743a5a38fee66c23cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c319cee0b67acacfba1968813bba4139bac9e5a19496d856ec2116e619e6d372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe5d1dee5cc4e97f4e4ee82418bdb39555d1549f44e745112d1e994c0bb6bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9340b7fab7add980ab1239cfdbcb5ad8276fefa235d498bdd1b78401a7d5e429"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end