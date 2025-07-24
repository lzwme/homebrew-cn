class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-07-21T05-28-08Z",
      revision: "ee72571936f15b0e65dc8b4a231a4dd445e5ccb6"
  version "2025-07-21T05-28-08Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "315a43ab7fe01a02abb2062c63ba3f8620382f4908bd5aef87c7e2d934065aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3100c8eae3feff96faea043cd653a93128d8f7fca327f93ede29a60b63e00632"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "159f23ccbda1e306640d9a98f32f7779b74fcc0774115b5d3a8d56f4ee2d29bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c62cc6be5aa5a9575c6602f38270d4779fb37303b4fcb9d08797e55d33889d03"
    sha256 cellar: :any_skip_relocation, ventura:       "dde800a160322e0c415854071bc9f0c6f8b987e3d485cde9ca355fd097a373b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fecf2a3e33052449622a0d8cbefa7f2b8a742e6709d6cb1386342c70fb69247"
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