class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2023-12-20T07-14-22Z",
      revision: "8e1573ec1b9c174e9f8d82ee9996d002c1d9caaa"
  version "20231220071422"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a14fef62c3418b32fe9dc8908ec49950f2e017c20a2d92f7dc5a0f69192757b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20370825c65f83320cac309b38d6179cefd57e5efce8515aea206ef00dc89e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23297c458b05e84ee1e17202f07dc0eaba6a2bc7c3b01c3a3e5a2a3e5aa2837c"
    sha256 cellar: :any_skip_relocation, sonoma:         "72bfcae54284a5088c19093870e14b00fb9a1f306d0e060bc8ec1ff5d39cf478"
    sha256 cellar: :any_skip_relocation, ventura:        "971c28697ec4a59c548130ebe28764b81c8f648ea4379273c86110db6bc7c123"
    sha256 cellar: :any_skip_relocation, monterey:       "1c760da4e5952be7d96079ac6a66f43ff7887e703fac2b55ef4e51140ba4fd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d36ce6f2c0f3211c5ab47fdc95291de52a845fafc5352a6c35c0b157c86a4b"
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
      system "go", "build", *std_go_args(output: bin"mc", ldflags: ldflags)
    end
  end

  test do
    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end