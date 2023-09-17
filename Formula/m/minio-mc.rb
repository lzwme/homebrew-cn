class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-13T23-08-58Z",
      revision: "e561bc770e9ba6659a13a094e08a530a9685748c"
  version "20230913230858"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70e96da4b05a017ad9eb1a3d0befd2c318bc6760d3ea32472e53851362023dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28fab49f0aada04b7340e7ae50a168b57eae57ca108dcf6c6faecc7a3fc4dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba780fdee85a690ab77d18f48e76b2f5acd615d330e7ac5f1cd649fffe19e3a4"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb921bd912a69d2cecd5dff02214ef9c6873f81b352fdad7e7630e47ddaeb2d"
    sha256 cellar: :any_skip_relocation, monterey:       "18da71672af8332c4c4eedd3cbd8bdf65d1a0b113298a03ce1903cbefc98d98b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1cc147bbd73e121ae77c67de60e9538f25db323d0628e62c0d9ba56b87a256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05fa8a75785f17645942a0683c710f3e35af6ab73f610cb65fb1227d66a44c4f"
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