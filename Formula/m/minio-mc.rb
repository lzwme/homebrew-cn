class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-07-16T15-35-03Z",
      revision: "2676e50bc1b9e71d4afe2549d34b8b0245d7a370"
  version "2025-07-16T15-35-03Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcd6077adab16b4db0fa34ac3723210c6e1e290c3a82dec01084a058d8bc3bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a4358eed74f4c0dda00e15028247aa590dae2f72d6e0e915826ae77b1d1104"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "502fb0fdd08cd44fab3b9e263d58eef0df9c9e21d20036910042685a8880f9d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "15125b9e3aa48e9d59b3e8043fc09e5826fa76972ae2d6f484ef2a01821acdef"
    sha256 cellar: :any_skip_relocation, ventura:       "671c1fcfc1940280b2a6f14ac512ac14188a4a749e9cfec16097b998f2618259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88f286a347e71fbe5f822302704be899de0f7442f50064e491138fc3086b8035"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      ldflags = %W[
        -s -w
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
        -X #{proj}/cmd.CopyrightYear=#{version.major}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin/"mc")
    end
  end

  test do
    output = shell_output("#{bin}/mc --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    system bin/"mc", "mb", testpath/"test"
    assert_path_exists testpath/"test"
  end
end