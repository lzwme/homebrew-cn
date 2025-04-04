class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2025-04-03T17-07-56Z",
      revision: "56f94fd375ee0aac2a917f14b6ff401b892029b4"
  version "2025-04-03T17-07-56Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa101ecef85d15fe6c449b7eb51f143b6bcf8629bd2c12cde95da9049606bf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "278992169d2f05dc41ea94ebc2afd764812e79bc1fd0a8810a9edcab077424ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9f80b76bd95e0115d0da65b8568b291eb8fcde7b3a6cfc88e8b0ecb7d724185"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff051e60b0350e11f9e336315fabf7a7e59ac259dd551ed7608673845309797"
    sha256 cellar: :any_skip_relocation, ventura:       "1dc5bf7d45953f6c66e44377105d7a23caf68c6fbeebede73be6407914fb2e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "854d91b4a485796e351a643a6cea2269cef2c18eecbeff3d4e8464f6754b497f"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"

      ldflags = %W[
        -s -w
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
        -X #{proj}cmd.CopyrightYear=#{version.major}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin"mc")
    end
  end

  test do
    output = shell_output("#{bin}mc --version 2>&1")
    assert_equal version.to_s, output[(?:RELEASE[._-]?)?([\dTZ-]+), 1], "`version` is incorrect"

    system bin"mc", "mb", testpath"test"
    assert_path_exists testpath"test"
  end
end