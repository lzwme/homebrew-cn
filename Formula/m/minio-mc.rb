class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-03-30T15-29-52Z",
      revision: "9f8147bf0e037730077a1b3baef25e53181099b0"
  version "20240330152952"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7759ceffb62bafe77eb18fd2d7e262e130eceadefcc009136a99dbcbf3bb3f93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12699fecb75faba881841b1055e61097d188b0d58c1cdb5d27446ebc5ddbc4e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12593fd2f6e1883ef2baebf6b2de71085fb9aef3db0551b5f3cf523f58c73e51"
    sha256 cellar: :any_skip_relocation, sonoma:         "23c792913a32ef43655317eba18b10636f2ff94cc0e5ce1d586403d3c4e3d307"
    sha256 cellar: :any_skip_relocation, ventura:        "c2c7bd7923da763331d585a87761636f91af1f32e220b1976a58cfd695728450"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5b67284acdda3044e6b0c9a2bfb35dcee7f87982b1aa8c20d62632ef9a1bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22e57659b0ec8d5e265ef083b57bdf134894af25240a4044b73cca15d4621dd6"
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