class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-01-13T08-44-48Z",
      revision: "799ded568dc7a40547e417be460de37b985ab11a"
  version "20240113084448"
  license "AGPL-3.0-or-later"
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001ae6740da2ac68c8ed112ac10120519d438d4abb3b532019926ad5a19b252c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63e1f4bac2e94ff41156bea929f5bd87441b31a803449ef444b5034db2726a14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a64fb8e43395846b50f1d35bb9866c1335c2565148d34f0f34e24dfc3a03b59b"
    sha256 cellar: :any_skip_relocation, sonoma:         "500f1c20206158b7969d435d60dee62db8e396fb034f8bfddf5881ddd69186fd"
    sha256 cellar: :any_skip_relocation, ventura:        "81e89d862d049709af49031a727cf9fab08168f4563c07f4f84ad566028c35c3"
    sha256 cellar: :any_skip_relocation, monterey:       "51a630a5a48060e6da32d783725ba5add00fd52e674bd0d040255498d31de1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb6c146d8284385b8a1b12d964b35d03166f2f01b500c6fa3d5bceaa1fc7e52"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"
      ldflags = %W[
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin"mc", ldflags: ldflags)
    end
  end

  test do
    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end