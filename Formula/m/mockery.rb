class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.46.0.tar.gz"
  sha256 "21144b213dafcb17c225777f7f8d5dc29c90cab05e25ec3e80564583458d76f0"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "395e422938460705f859164412a4e92f07508ee38319e06f072d524c15468abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395e422938460705f859164412a4e92f07508ee38319e06f072d524c15468abf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "395e422938460705f859164412a4e92f07508ee38319e06f072d524c15468abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "155f9fd4130c943cb314b6a8ce1237a46040b4bbbe67f09c641029ba392ca6de"
    sha256 cellar: :any_skip_relocation, ventura:       "155f9fd4130c943cb314b6a8ce1237a46040b4bbbe67f09c641029ba392ca6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46fd8531c64cd1c2234b69da68bc661b870ce6374345f9aaf1841835e947de46"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end