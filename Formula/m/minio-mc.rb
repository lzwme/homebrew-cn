class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-01-31T08-59-40Z",
      revision: "62b12a2770828f9d35ee7c5614d900b95ff6e6ab"
  version "20240131085940"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbbd951aa96cbe1a8780b83ad231479effd5498b6e1acd838e9c60b83b342317"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d45947b87fd142f1f27c6c4384a1b270cb0ebb7b58a692d6fee4fa4db355ab83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633462921eea33cb020121001afd6e54479e0594f64dc2d34705af7049eb3080"
    sha256 cellar: :any_skip_relocation, sonoma:         "11484f490a4ac91ba2b67e2dd26d6cce59413f2fdbafefa1723b7a92c75a1a62"
    sha256 cellar: :any_skip_relocation, ventura:        "a29b3137bbe69df4f7274ff4b1be9e477bcd207f6815ec448649c21fc197f2ba"
    sha256 cellar: :any_skip_relocation, monterey:       "cf56d5a20705d05ce67accc33722f86b3e1f9b620d28c9f14e108640f1843102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be82ee44aecd31a8e13ef762206c5c48aaccfa480398b64939273ac4ea64d1f6"
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