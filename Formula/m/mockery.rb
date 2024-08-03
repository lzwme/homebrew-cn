class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.44.1.tar.gz"
  sha256 "7a9e8cda685c6b0244197a3d3c8f696d8f0e2ffa74cda3e59a4fb7a19afb751a"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a84796d377a4ed62e259442fe5ba20729e1442971e91acf5cf89a165c5cd75a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f32e751f08ace224b21665b99203cb1e6889ee2b94d46b9c3e83cd2c82f93ded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00942bcfd0266875c80753154d79c926b6720b5795c02da17099b70d2cca85c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd5e04a3701438c576ea4b0923891acb0f31c714f5761c8cc00e3e0fb1cb31d0"
    sha256 cellar: :any_skip_relocation, ventura:        "06637841e955193c0e1613fbc00964dfccf78d9fea556fa14a7970f106c67fa9"
    sha256 cellar: :any_skip_relocation, monterey:       "c6407e23eabceef5f4456d6971fbe5fa7ab6461629e4601289bd5d48534d65e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b8c6593f93719c3eaf1d65622dc75e8f6864e4eceb71fee3f1bc4e06e084eb"
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