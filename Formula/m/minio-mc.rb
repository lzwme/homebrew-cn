class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2023-12-14T00-37-41Z",
      revision: "8da737f8fd63de58dc475bf88eb9e285d206e3ae"
  version "20231214003741"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5ef2d951a7ef9fb337b57844c6e7e6dee37c08074c6ae95fd7b509863be338e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6b43965b5aa2a96e738a494d27f25784d4eb9be313704d7c065c7e11a05191c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88099c40982fd1ee02b42215af9ff63b02fcfda0dae127d687ac207138d53180"
    sha256 cellar: :any_skip_relocation, sonoma:         "06661a27a73029c6ba72be50db66076f87107e1b3dc1e511bab0bceda750a008"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0293ecfd331b6e7fa9954de2e451a4ef6b4856d71810e17752f516979a8f66"
    sha256 cellar: :any_skip_relocation, monterey:       "cc0753a044165e5cc938d34f123277f1ff49929a15ed9fa9c245cd874bb30d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4cff36256dd888fba65861a2b83b8a9a964a26911b0c4653e13c440b8d9759"
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