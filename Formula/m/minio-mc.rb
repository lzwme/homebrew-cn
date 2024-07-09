class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-08T20-59-24Z",
      revision: "21d3ec0089a1fa297cbdc23db413012535e2ff9e"
  version "20240708205924"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d559f47115f0182c6d0eda835fb74bc6bd07892f5c61a0d1defc39bb60ea6ca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a98ffa92eca134c8e2b79447c523d445e3e87b3f038aeeaf7ccb0020e90aae1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e1df153c30c3ad333d4d6b4f21e395453747e086f8c3b340ef929fbb90b00e"
    sha256 cellar: :any_skip_relocation, sonoma:         "780a2a002d7b56859ebd2821768500d46a622af6a89af4cc1292d4477cbb5819"
    sha256 cellar: :any_skip_relocation, ventura:        "8aa6427620b814ec0f917779aeb06cda86ccf6e56a78307dd71f13e75a07b8e2"
    sha256 cellar: :any_skip_relocation, monterey:       "14cffce00abb9201e269ee34a0a831ebee5ced477d5dad6eb4b74cbbc84f1f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2dac809bdf4e9af3e63abf95b53cc1696f0bbde7d2c7fe05067d2b3993c803c"
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