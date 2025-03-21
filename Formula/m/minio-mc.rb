class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2025-03-12T17-29-24Z",
      revision: "c1d5d4cbb4caf05afef3ea06a91a56bd778336de"
  version "2025-03-12T17-29-24Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cef88cd24ef1e038c3baba4c255dea2e3155db389965ef5da5ff310604eee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d865d22a208966ebd510e233faba29325cd9a7e210a7ba36be5856a76363c4c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54291fc6fed65a558ef8b54e0cc4c31b36ff73f9e061c1755033231280a937e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "51db5c1e042363d812f874ecfb318364ef9c9c8fad97b0082a3d1b6fd3508a20"
    sha256 cellar: :any_skip_relocation, ventura:       "2a791ec089b9a66410828317240eb84c99a4f80577cc64cce40faf33ba1e5f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29a463971735a35dabfaff3f4a917bf8aeec47a3998c909ed6aa21ddba7b7a9c"
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