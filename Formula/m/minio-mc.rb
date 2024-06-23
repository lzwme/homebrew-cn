class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-06-20T14-50-54Z",
      revision: "dda9e96887a452b60f23ef18ea68e8898836c017"
  version "20240620145054"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9dcb4db31ed60090c18f649cceb2201233ac87d0f31a203852a8fe30f8e27a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d16e9bd2ee7ac8f9336c4071cd12724219b11aa5618826e200512ef59e01b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52ed924a336cff01e99579934f4efcecf91825a14903c244a0bf81fc9b02a06d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b359b0b9c1a930c48b907f7eafbdef24e011924f370b79bab3073489c32ea6ea"
    sha256 cellar: :any_skip_relocation, ventura:        "53941ca574ce83429cecddec3ecd4b304b14048fd401e033798e7c44efec63b7"
    sha256 cellar: :any_skip_relocation, monterey:       "6db914006a82ef708c577b34c1a47635f2908c59a344ea5bf4832f7b256641fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8c82444f34faa23deccb3a92e9c2d331bdd0b7a1a2a31a8daafc58712669e4c"
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