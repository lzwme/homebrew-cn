class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-09-16T17-43-14Z",
      revision: "11ebe952ea30e426e564f66e78d178465ae7c432"
  version "20240916174314"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee5d5ab079ac14d08ce3392c5e39b848646b199397e8760e080cfb02366f0a83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21228310167ab71e2bd0fddd77202f9ac645e6f102936e232a278122acb7c98f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64d44fece777427b6ca66f77987d01112af7ae5b6c2e0e7a61b4ce8ce9dddf43"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a7c9eeb2492c18c65b5f76a2eb823a167d47ea93ea614851f64fcba131331d"
    sha256 cellar: :any_skip_relocation, ventura:       "708aa93f1aa1b1bb6097d230917340fad77ae3e4cd58265155f38eb8955d948b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63fc22d530ccc7c9f5926ba0ee7974d58ee3ff4fb0731d655565a329a9f54d15"
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