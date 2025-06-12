class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https:github.comminiowarp"
  url "https:github.comminiowarparchiverefstagsv1.1.6.tar.gz"
  sha256 "c125ce0c8043c62e5683f1519e529ca0fcd43c320e828a3a66255f58c494ede8"
  license "AGPL-3.0-or-later"
  head "https:github.comminiowarp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4626aab4abb51ca6aefcee735a7affbb87c174829be30ee90bcb853fb4ca7b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c278b0060df9695bda0e0bf5100cc78d415154dc3a6e8586871865dca9429193"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8731894ab29a296cc82b2f8a1b8d84df820ce197fcda5f1920c51b87645ed1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "796ddd72433e05cd888596f5ab1b075a30d3ea38e2a8f3ac2266b840635fcc8f"
    sha256 cellar: :any_skip_relocation, ventura:       "37168b7893e3145c4476f70cd3fb5ab8ffa8e6c3830a26e40d26b25f558d0f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e0f7b5fa46d86ef81f1c5174110a6dbbe33797b81ae5a09a53a6a70d933e12"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comminiowarppkg.ReleaseTag=v#{version}
      -X github.comminiowarppkg.CommitID=#{tap.user}
      -X github.comminiowarppkg.Version=#{version}
      -X github.comminiowarppkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"warp")
  end

  test do
    output = shell_output("#{bin}warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}warp --version")
  end
end