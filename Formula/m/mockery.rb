class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.49.2.tar.gz"
  sha256 "b8f89d6903ec92dcfe037a314ce546aa066fca314218651b50639dc9e0e9d8a4"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0606eaf50dfd882b07e03b81d1b430ec0d6d96e95d1dcf171f1f098f5c4fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0606eaf50dfd882b07e03b81d1b430ec0d6d96e95d1dcf171f1f098f5c4fce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0606eaf50dfd882b07e03b81d1b430ec0d6d96e95d1dcf171f1f098f5c4fce"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb417a539c08d1f1e07e1b99e4511fae60c9bd0c28ea794e6d7a8c05d447c1da"
    sha256 cellar: :any_skip_relocation, ventura:       "eb417a539c08d1f1e07e1b99e4511fae60c9bd0c28ea794e6d7a8c05d447c1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ac807df6de8ba1c3be60b76346550138ec59c9d2edfbd0980c0b7bd2ca9e19"
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