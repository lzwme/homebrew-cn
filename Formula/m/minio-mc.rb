class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-11-05T11-29-45Z",
      revision: "6ac18619cf881074fe6edcc79ab62c9c85da60b9"
  version "20241105112945"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ba2003d12a1d0d1d5e1ac01be2eb9adddba11c9cf162b862f0023cfbb5dcc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bc0fab6f39c3d08c0fbf38bece352f68dafa691365ca2f3bce500f0a1f42811"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9ba286847c03a09e4a48dbbc47ae6b9871eb58dbf02ab4b843d829cb25f70ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "870c31a8dd07acee6d3a6dbfac1a1f3d8227dafb7d4c7ddf7f4f7c78aab26d20"
    sha256 cellar: :any_skip_relocation, ventura:       "62fd77c5d69884b039bbd3ea7ee05e2c1d3959ab2d671d03b254648dffe8240c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37eeb5001d79b740c11bbca905215c36e793218ab30caa1c7ad62fb8a8fe3c17"
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