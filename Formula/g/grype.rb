class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.78.0.tar.gz"
  sha256 "64da7755b8f4169003a66badcb8f9432138d1ff59f805b131d9ac5a44391dbd4"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e55b9598cea46aad46b5cd258937abf017b21d3a41834f8eeac2da2a1fbad5a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a646d0103a622126d0b70d3a2186f337b662567738be35dca2183ba5a04934d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94e13a23055c94d39175f02420f6fdeae1f6ddb1064267f5b66acba5f1f82cac"
    sha256 cellar: :any_skip_relocation, sonoma:         "10a17f12843c7d2aac08717903e5b6d65019662ea5cb3b95c75731b169fe1135"
    sha256 cellar: :any_skip_relocation, ventura:        "3ca56d6ffbe6490bda665cdd74c22e64b1ca2918a1026e369f52fc944dc37189"
    sha256 cellar: :any_skip_relocation, monterey:       "52083880544e76e12897a21397a39bb24e674afc67316185f7cd908fc9449eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e12ad9dd0a1ea6254c3af88ae3d0a2f37cde34d88e8c74ae6bbab0b88d51e81"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end