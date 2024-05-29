class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-05-24T09-08-49Z",
      revision: "a8fdcbe7cb2f85ce98d60e904717aa00016a7d37"
  version "20240524090849"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3a79b263fb49de2dfa7aeab0403f0c05f372ab9154c51663a9faf0b527c28b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19dc7399b8adab30330c82614ed11d7cae88d9e6eaac85d3aa28e0bf593dd86e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33cc3119206152a4ea71278748bf8ea5d95c81820fa4ed4c29a78ea19424e7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e58dc170adfc28d6f919ba9b4b7db4a51c49dd553ba2e0502305ee3639c94a29"
    sha256 cellar: :any_skip_relocation, ventura:        "f068059f9184b99f67e89b0c3a6bc64ebd17620ffe442f540f017e85aab73f07"
    sha256 cellar: :any_skip_relocation, monterey:       "6dadc0398635ab76d2940d499825aa31fb08028ad6de0962bb5e7f02db38f04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c130d91624f1658c646e483fc4b4380a344354e93b4e437c1ec894a4287c2e59"
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