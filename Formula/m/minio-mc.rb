class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-08-30T08-02-26Z",
      revision: "5a5a9973c3faa73b23d15a7d90d05be241311a35"
  version "20230830080226"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06b80149f572ae0747201780de17308f2d833608a7b88c12b6aee5f4272db104"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6786af40ec8cdeb8dbd2beae4bad559b073aca4ee0b9fd05b6558f60fb1a6c06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df6ae90647d875c48233425308f7801cf1c9d30d519ed4cd940e9f5ab573fe48"
    sha256 cellar: :any_skip_relocation, ventura:        "37ca00c437d1312fc9763902eb2d609e9d3578830467ace8edaa3c3a0ad29be7"
    sha256 cellar: :any_skip_relocation, monterey:       "930411a17a50c424302aace1516063390e9a8a2d2dff0777da15b6a3abd5d422"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd492127ffed7a5c9805967bd8a3e2fc622d169b443b5aa6e6c84d1a57ad82cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b21f9c98c07a6a11ef0847381507bef540848f88d264ddb204ad9bfb3334da"
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