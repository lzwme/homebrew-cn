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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146713947a5bf92282f167729746e66f379d085120fa1177a9e6714a31de31e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d44abce960eaa9004ebcdc381350c38e29deef045c67d852386a620aa8d683d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2ec5d8ce21a6c90006317f93fb3d5cee82c23eaa3155d99331774a79bcb9156"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b37b568b8ba77eab88f752dd713fa0babd5e01c86c5cb35565fcbe72ada8bff"
    sha256 cellar: :any_skip_relocation, ventura:       "c232fa0b0e151c7c2b43f9a297d4b6a5328a65d8f5b011a83f72d6c952efef8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6205ac291ec6fa1f20d3de333c6f820cfefeca924c52cf4f6ede4bc6489623bd"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"

      ldflags = %W[
        -s -w
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin"mc")
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