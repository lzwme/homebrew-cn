class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-07T22-48-55Z",
      revision: "9dcef8825fae8d438fc0be518ecd5ca289f6e18f"
  version "20230907224855"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c46be155692e5ab7c88d2f5ed1a20919d42f692b75fb0761d9295890f3b38266"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb8d0c1118b2a0abf2e0361e54b2284b1685a9862aa802453e32314b9c275a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a554cff0f44ee735302d5f1ddc610e5e6e3922d96967c4ff9d37fb819db2313"
    sha256 cellar: :any_skip_relocation, ventura:        "55ef8fd9b381618efbd69c987ab2ce7c923d41b5fbce2dc5101cb0dc062e9e97"
    sha256 cellar: :any_skip_relocation, monterey:       "3854c274b870b167a5ed16e6a3a3c936c326fd0d5bbd9e4d60f694a8a2acf380"
    sha256 cellar: :any_skip_relocation, big_sur:        "5865f96574fae8ff5d29b7907ab66aedeae70c860b626a3726d0c5d8e134393a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08762638f3094b6fd68ba82813b719276b2be955ecce3b28d329d0aca96b86f7"
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