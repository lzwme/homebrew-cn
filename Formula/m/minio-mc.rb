class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-01-05T05-04-32Z",
      revision: "59eca9fea8984adec1e8e7a1c95d0ea23107ceff"
  version "20240105050432"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b96036dc49ae5f5f769afd228b33be9762c15d11a67d532c57f8bfb86530cce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbab548778107f50e05e6c7a42eeb98d62f811a18cda7b818af86289b48c61f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4977e569cebe258ecd175f8fdc654e1d1b1bc04b01ab8044c48bfed0be3d18"
    sha256 cellar: :any_skip_relocation, sonoma:         "d086caea40420374acece0c9bda87f197e2f5ed48fea6b55e796eed0311ad609"
    sha256 cellar: :any_skip_relocation, ventura:        "028eefabf28d635f0cab2e36390f7cc2956c75a38bfa234828b08c3c4eff571e"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d4491f1e5ff4111751b86fbd9753e457951f6aed87a48767c103fb9d4c7343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4981db4a47c381574aaafbef19da6fd32360ef9642263d50af3b9f91c8906b9f"
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