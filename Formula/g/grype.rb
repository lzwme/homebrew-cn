class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.88.0.tar.gz"
  sha256 "7d0adadbe0ff88b4b62782f8de7f2ecf7ce17c61560cadd9a1c0fcd1f85d1b0c"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6bb3a0ebfe23953fa49429db498e453f5fc9ec877444255f1e584514d89772d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4282b276d18fa6f8019cbbb8927f2e793a790ddf2404a5387ebe809521c98cff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40305dda4dd0f2c020e9d0e3f4dbec42a9ac0605f898c4b90a3ca2dfb0991408"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb95a46b7e1408529e9c57f955637de203912d30b238837e2de49274c2931ba"
    sha256 cellar: :any_skip_relocation, ventura:       "03ec00d72cb32493c97c7be8418bbda3eeef4fb538073de763d3590a41fbc214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07522c92ba8dbfe0e6e08c456c9323bdfc8b268ed777afff8eaec992c48cb593"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end