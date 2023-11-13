class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-11-10T21-37-17Z",
      revision: "56803d21674f9cb9960b86381fe2c527f51fb07b"
  version "20231110213717"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "723b8f61cfde5a8c2f68f044d2b78d6136182de9fe58bc10b435d8e4358339bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e5bf34aa55f86b0bed1263d377fe1a443fe6b1c63b558909cffb65e9cb67b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acdbb49be07ee9d7ad6ccab0b7dada9c6d155101ba771786791b54366718b61a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce1bcfced68f7753438003f3363c5d52406db143769da9d1d8236cdf61cdedd1"
    sha256 cellar: :any_skip_relocation, ventura:        "58db989847f2bb994848de5353f13b2385bc7f985f4aaba986a4a234f23c40db"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9c9c92f231336c97e17784616d22ceca428ed534f9bcd7e7f074e202d52f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a810ac8a0eb64ee311a8048bd1dbf79ad33aa5aa811554c43e6500854fa2b87d"
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