class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-10-24T21-42-22Z",
      revision: "75e722216a2269b39316494a66e1bfa182c0403e"
  version "20231024214222"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3a91916af5cdbe136556614b06a4298c0159143c2b3813c0d331f682b7bbe8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68bb8de22e37ff692f11ff76d4cdd5b8ac56ea7c5519e96bdab6ec39f5d112c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd745da83ebbea89959be334035c90e616378c52599203083dff2e174fb53df"
    sha256 cellar: :any_skip_relocation, sonoma:         "54c6b45743a1ca7fd1ad2c8908d5690c8b2b453e0e5453b874ddb078251117e3"
    sha256 cellar: :any_skip_relocation, ventura:        "d6b158ca5d45f8c385a4ecc736d219b7ad99cec95dcab8597fa91e04ff195564"
    sha256 cellar: :any_skip_relocation, monterey:       "c50628ec94c284bc1ff94749d05f3fac7bdba51cbcaad7263d68832c7d1c64a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b694b2d684f7c0027b84733ecdef51509b1b9e8370cdb7ab9bcdd2b3ad7239d6"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end