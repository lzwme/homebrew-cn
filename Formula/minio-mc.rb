class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-07-18T21-05-38Z",
      revision: "216aae32b9685dcdb4fdb83b6d99b00545ac6ab0"
  version "20230718210538"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9b44f3cbb911837087c7c335be4a4957a5f78154ae5463860e679156c94eea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5738fe26605553d72c49121352354eef0fc0022590cffef59d2e44828e8ae3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1423dd32128eaa4f205b8c941935de690c8b12cc9fc1e406918d28864c38957"
    sha256 cellar: :any_skip_relocation, ventura:        "6c9672c7e111635cb6f6cf86182865e7ac8e99c03c043eb07376de8e965711ec"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d6d1ff04e274e3be8a06e0d329591cc05bd2de35eff55b0e7f381945a6aa41"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d09054eaaf19ef457ec65e317906ff55df0a5d5a694d68c7f778ce20dbf0b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d1609109c4df724852ab7d4afff41e0ad8efdaec30fc6d0cc6cdc2978d2bb38"
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