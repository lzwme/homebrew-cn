class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.12.3",
      revision: "438f47256f0decd64cc96084e22d3357da494c27"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de84d654be1075c6936fc7f79a12e061e105af971e7ab651c6b5030c3b024682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7619de53c6ccdee876863450fbcb2cdd2e718bbba686287c4e884fafe2e6009"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be94a727a23226eb7fbf2fb7bd11336516ff14e684b4940d7f59f81a468397b"
    sha256 cellar: :any_skip_relocation, sonoma:         "94aa7e52be101175fe635f7a785f461860223db688db9ed81da04d7e90c55a6d"
    sha256 cellar: :any_skip_relocation, ventura:        "3229f1b0e31be6cc1dc16abd5bb332581848e4370dd586d489b7e8874a60c03d"
    sha256 cellar: :any_skip_relocation, monterey:       "f1cff0ada3aefbc7d7d5791fd0ff45c51fbb0e1ed67fd6d907190e5a12aa5faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adfb70ad2611f7ba2af308ef9abbb7b8303cf19671fd3b1b92cbae680d895e8"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end