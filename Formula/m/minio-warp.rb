class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https:github.comminiowarp"
  url "https:github.comminiowarparchiverefstagsv1.1.0.tar.gz"
  sha256 "f8a0f0bbb2bbca40b945c7ab3d5e1936390dfc796e12c2b87e61bcd7b1faadc5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50aa830d00b14e9700cf15bd79763c385c18218f4853b711e8c12e5fd3830c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f37f93180c3923192e3cf1192ca2b6cf1143f254ef9bd9b1086b470d6ebace"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "264cae23fbb0b1ac14b1fa8c530b478542b8a321662531ea3a61483a5e1a1d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2b57408488a75c15ec3f8bea580e10382af3b1828d45e8f65b7ec43ed4007ab"
    sha256 cellar: :any_skip_relocation, ventura:       "2ff12cd5f860a12a4f6514b362f68342cfb647a30c8589482aedd10654027e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c597d155ef70239f9f508d0f85a28fd1b705c23cb610b6e130648eeba957280d"
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