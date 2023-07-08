class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-07-07T05-25-51Z",
      revision: "1b992864ee0682b8be6a590ccbda080475dcadd3"
  version "20230707052551"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f3ab47ce0263d0676464dcdab785297c726ca1d139dcf05b2eafbffff97f327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c30845a99a59e69e686868cd03947ed8ceeb9596d8b3e7d285975d7a98a72db9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa2f852cf4716e013fb9dd8ef8db733030c8153ce556e6f4025b6097804ef330"
    sha256 cellar: :any_skip_relocation, ventura:        "f029d462b8e34f408c630dd461bde83b1f30797dd6d167d569ccaca69a3eb34d"
    sha256 cellar: :any_skip_relocation, monterey:       "497d90a36a9cc1e0af6095980737b4e7a5c6751d283d67a8ca512ccb4c127db6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d6ee85ce9c5acad9efeddb9cf20eb4d15872e726f26d8e476ce09165b7991c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b45656b2f4083b28f0d0db858663306dafad27af0f7367154f934d7efefb018"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end