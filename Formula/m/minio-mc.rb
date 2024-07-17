class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-15T17-46-06Z",
      revision: "11034f9de1e9f993c36fbad961f76f876a753328"
  version "20240715174606"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98b7376b3fe9a9dedc0d0e186cd4a8aa7c1ee2145e22da9bc5ee7d482df3d180"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c70513738f68b24819672ced0846772b25e1409c36100d3b69281c8c04dde3a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c53a634ac16916763c0d64ec0d9b606e457d1ad56ba300493c1815c711afb50"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd888576cda23515aec9f51d4fde27f596adbb0851133edfd747cada6ae0d663"
    sha256 cellar: :any_skip_relocation, ventura:        "d7bea41a873b640f7af973d871d12b8d02771bd8e0525757d87d6490a19004a9"
    sha256 cellar: :any_skip_relocation, monterey:       "06aa5f463b8047688517719f8912e3aeaac1b972ed50588a9ac4cc6bcb47e05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e500a9d6a65856e180d83ae52dcb28b3c504c0b16dc27b1ffb118ce10b08070"
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