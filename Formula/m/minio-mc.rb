class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-02-09T22-18-24Z",
      revision: "669cb0a9a475e4f66d837a305800d3eb8ae784a1"
  version "20240209221824"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8591d9d084ae2cf7843d7cf63c6f72efd78f14487d264f158265df9263cc9f9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46367ca7b0f47a3a41e4cd7ec42cd6f8bf6fd1a00d270ec4bfe560c06e127701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a0fc3852391b7221d1920a68e51b1c73eff2b3c16199359324c99c05469368a"
    sha256 cellar: :any_skip_relocation, sonoma:         "456ab6b4dd8bdc48a4a72e302f45fff66d5ed4276318ff11d35bfb7d626d3c20"
    sha256 cellar: :any_skip_relocation, ventura:        "20b983122dfa284ed60c91c6d958b28f6c7104793ee17380bc43a37a57a22c90"
    sha256 cellar: :any_skip_relocation, monterey:       "95d0703275ffff98452b172c7fb86a1ac89a35d11ee7698ce90bd561979345c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95f75e5c1f6b0647b92e2a1b462733e6b83532b08307d0d3c070f8b43e72086"
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