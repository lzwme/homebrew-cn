class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-08-29T22-55-06Z",
      revision: "9da0b405db31583514e47ea43a9fb191339b3f97"
  version "20230829225506"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dd1cc48923b73bc9be3225b940b52a16b8157f8d7edfbd85c1447172dbfece1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fce38f4976c465098b5b45ea7ebcf261b244f328caa977f910a74879302a8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6893a1c1bd0480ec55261d065769023705ca079989ea8df385c0ad2800b8fb6d"
    sha256 cellar: :any_skip_relocation, ventura:        "c5c3eefa38e67729c51ef73643072309f1369ed1380cc4f04f563968cf2c65f9"
    sha256 cellar: :any_skip_relocation, monterey:       "eb0baeba61dabc30b19f12b4fbb555667f197fca2b54d14d61b039e93867413f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c189e3cbc0efc506d519f0fdd0669db0629b4c85a764f6584d06bf3cfeab1ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02221e8f73d461dea7be02049d4cfdf1c6616cb3da5b8a9d7c0315fe82ee8c5"
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