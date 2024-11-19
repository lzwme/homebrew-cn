class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-11-17T19-35-25Z",
      revision: "bb4ff4951a3e54bbee6ac75cfaf387c521e98709"
  version "20241117193525"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5c2392867f48de6e53a29035d6a25a258241ea85ffa9a676508a6ed27ab98be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b72ae64437500b7b8bbbe053c03b65810a0f68f6f91372b47f37348dbe2f9a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f93fbabf340d6750e347a9991c51f53f06c5b20b01e2fa6c04e8702f1e896f07"
    sha256 cellar: :any_skip_relocation, sonoma:        "5931dc8819bf54db796d14a184a9a55cd16a71cb84230b22d86d63b2fcbf28b6"
    sha256 cellar: :any_skip_relocation, ventura:       "7f002d857dc48cc291d14c4431a4cb420000c2ac67cd3318c778d50c6477acbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d301447397950c2030438e4dfda667e02dacde13667d386cab788a8c1a0b1472"
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