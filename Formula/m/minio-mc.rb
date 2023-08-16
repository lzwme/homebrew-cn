class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-08-08T17-23-59Z",
      revision: "01fb7c5a96ccc8bab434d1210847279710c8ae93"
  version "20230808172359"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5826064ec3b8e329973bb8ca470164a65a48f9b89f429cfee625d5a41481e977"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b19d0e7032d5f765f23eb5913ade29dba84d7c8eae29ff7e19ab365e798264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90971717234e66c07a5681e757b1934f1216248b8a7ab4dc209869499505c46"
    sha256 cellar: :any_skip_relocation, ventura:        "e195ddf69f652ec31f53cbdc7036cf837f65d271efab1b5a40d00c1434dad09e"
    sha256 cellar: :any_skip_relocation, monterey:       "04dca07a3e99e06abde9f77fa99056f62350da318470f17bab1ebd9025a1f68f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d81a69d569863c36815717dda1676ed2b6697530f4b47da6aa2c74d5b7d47259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "628ec095a053aab056e3fa39c6c5c76aeb66418598b0f45f33d60772feaadca9"
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