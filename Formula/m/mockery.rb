class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.50.2.tar.gz"
  sha256 "9c0f3211609dd799011440aab8b385d7a31b27966c943eb53f89b8219066d126"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c458f4da205af8dd1a8ebe9f42d84d336bf1d61ae41e24b0f47eb810dc4a257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c458f4da205af8dd1a8ebe9f42d84d336bf1d61ae41e24b0f47eb810dc4a257"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c458f4da205af8dd1a8ebe9f42d84d336bf1d61ae41e24b0f47eb810dc4a257"
    sha256 cellar: :any_skip_relocation, sonoma:        "d158a8c7bfdce2b80dc535cc535bb6bd6f26cc230a13545941281440e0a4c75a"
    sha256 cellar: :any_skip_relocation, ventura:       "d158a8c7bfdce2b80dc535cc535bb6bd6f26cc230a13545941281440e0a4c75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b140d5417c3c47408561f5bac02b74a8c76fcf672cbed318535d28aadb85c4"
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