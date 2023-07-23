class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-07-21T20-44-27Z",
      revision: "1c17ff4c995d772c97eed8c5a269f2074a9425fe"
  version "20230721204427"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e57d6e1c24e66c259b0bb942d7a0d09560352bf72d55cedb4fed5bde649586d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d6e54ca4b75423e95a2d29c32aba6d24600271ee846fda0d9451426e5d1d845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c010cc47ee7f871aabdc4f334e062dcfdde967df15eddae10a9713bbfd1ca8"
    sha256 cellar: :any_skip_relocation, ventura:        "60cbbe7fd16ddc70714e7b30a3f5d80fb5506e5209fe4d8cf311090d6ac26c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "7eac980c68be71de1c67fdda13688f7c83101c174cb4c91f13bff3347f89c11f"
    sha256 cellar: :any_skip_relocation, big_sur:        "57438a65ae8d4d033e3e1cb35aa27ac4019bbde19b53b1b1068180356755bcc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d345f8960ab2a19db1a9518d26fe6cf8e03b6d8bd906fb0540ef036a3b0b597"
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