class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-12-02T11-24-10Z",
      revision: "d920e2b34b22a15bca4cd081201d3b301c623d87"
  version "20231202112410"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee546eb6b9d228a2322c3de71aed383ff654ed1fe42005631eef0074b3f698db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8735536dae0429b8f61327ac8dffc278a9b8d369f08706d188b9515ccdd4b9e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd2495fc5e1b609e0c5f6addfba3ae72f8455d9e3932f28ca453498212ed488"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c6d4c6d36f2010e348bd707ebba3ce7f302d7d379a0a968e6c12ffe06ae2b2"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec64e2d2b313747848d149799db6f2b2db613c762fcf18cf6d991ac1b0bdb2c"
    sha256 cellar: :any_skip_relocation, monterey:       "61a4fdc7151230b03d55ec0c4b699319cb87f518ae6eee177f1980187a18f58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8886b90922842bbce97ca08db9c97d487e49a0d67ece7d90d6381b391ac616c2"
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