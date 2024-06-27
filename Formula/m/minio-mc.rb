class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-06-24T19-40-33Z",
      revision: "3548007d5bd1ba8e2ed98f35d95c4776dd9a7ff9"
  version "20240624194033"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85252a61f683b5a7385636726b37d6dd2ec27eaed0379546e15e8ba36184cd96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af68113c4ab932043932e3a8bc63129c2d8309399c68d22fcedab6a0f7aa600b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "070cdd54cc364bdd805d2dfb296273bf861313198cc38b2b4ebef19946831ea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5283816ef60dc58531a28742fb544255eec20fbe7c51c5f3307ed50e829c9ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "85b80accdce7deba2eb888f4b68e14b900d7171c9cd6e6866b84c22ff25abbca"
    sha256 cellar: :any_skip_relocation, monterey:       "424106fc0841294ccb95102a386a13c535f29843b963e189c68b98a41eda862a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425bf8dfcea0bb9b5aae41385057301acf07c360cb3e79347d5cfa3c09c80e24"
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
      system "go", "build", *std_go_args(output: bin"mc", ldflags:)
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}mc --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end