class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.49.0.tar.gz"
  sha256 "ab325b22254e81049dbc55aaff3b21f93b0ce30d5b163dbbf43268e2e91d3581"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed8b4104a2fc8e59a80e4af75d280d61435e5fcaf0ca5b9ea5018e2724dd1707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed8b4104a2fc8e59a80e4af75d280d61435e5fcaf0ca5b9ea5018e2724dd1707"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed8b4104a2fc8e59a80e4af75d280d61435e5fcaf0ca5b9ea5018e2724dd1707"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e726d35279904f10e6f3e55282bbbe413154651fd493b1d0ebf296229da89cd"
    sha256 cellar: :any_skip_relocation, ventura:       "8e726d35279904f10e6f3e55282bbbe413154651fd493b1d0ebf296229da89cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f9add9e5dc7238aa908ddffd1b30ff6f42cab2b0f76ffdae35f7474f6f603e"
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