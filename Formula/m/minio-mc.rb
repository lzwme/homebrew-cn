class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-08-26T10-49-58Z",
      revision: "a55d9a8d17dae78d0373691ba676170172765883"
  version "20240826104958"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "794bb10c669560a13a5d18808b12e30bd4b11f567235f392b3896878a5041675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286b8b32b4a888e7130c1f6ede581bfaa880a7296a9e2f49b61260352e72cfeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522c9d54494c17d0611f85aa6215305bae68e090cbab2f17dbf9b5b30ba8339a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cd78fa77f5802acfc5284c5b991068cc48357cd409e5f298de4bd8eb8dcacff"
    sha256 cellar: :any_skip_relocation, ventura:        "10a09f14ad9b3d9a63607933b8dbbc9c153ff35a2218aa52c047cc3ba2d02b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "0d931ebe59b4b8b116c80abca95eecafd1586faa1a7cf0aa1d78ce0d5c82d833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31e857a6bd88fc0d0d9d07be8721c9c61bad54ce4686dae77f0fc9bccb83e9bc"
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