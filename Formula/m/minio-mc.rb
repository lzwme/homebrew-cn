class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-08-13T05-33-17Z",
      revision: "b34cd742cb7f05595fdf65e4d121b67fc0008184"
  version "20240813053317"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f37b3a1a33f61dbad70b67245361bab86d8776af71e5b03091fb81bb143f900d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2be4810397b869a69369d05612075023dcd793bedae2bc87e2e2afa0cda1e823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba6921212f672b7dacd2296960cd7602706a82f78fd8346632fa89c1de7bcb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccbccec87e10d763b49f1811408c6fa6bcee32db48d30223f7c39a7f48e07207"
    sha256 cellar: :any_skip_relocation, ventura:        "a87658836d3fcdf986e2114781060258e3102d1ba0562b7bc232eefad4b2cc79"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe6f8eb7b4a83cebbf30f6acfbd9820514b112f33e5dda685e294b82e2a17b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a728f7921823b4065faae34c27336f82f1739d7d55e3a906b63fe424b798e1b3"
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