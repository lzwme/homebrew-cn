class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2023-12-29T20-15-29Z",
      revision: "5386533bb912918ed4a045154072bda15cdf8b65"
  version "20231229201529"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "599fbf816fd0802a99d2ec1cd976c2c7f99e2f14fa4a9c34094e9ac7ff31fad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f4883af5c0db226d9864515020228ac9466560b1d9b2f68e3320eee9e915d47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640ef14b60653167a6d7df2d2338e6c543892953067c27ae0fc7d1bde99b5425"
    sha256 cellar: :any_skip_relocation, sonoma:         "7617d8a2a933add9c2151cac13705b9e379adfbac4a97133863909f4948707fd"
    sha256 cellar: :any_skip_relocation, ventura:        "24aaadd7701e5607fbea57133c07f5269d99326df6471cb212755b329c9541b5"
    sha256 cellar: :any_skip_relocation, monterey:       "66de20844971502333136b55f87043a12decc20c277b9040b4eb4d0446faa76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d54af35f437d3418b616ca7cd77aa4ed1a3730454e7a913054f73f667cc0796"
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