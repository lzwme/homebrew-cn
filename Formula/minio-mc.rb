class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-06-15T15-08-26Z",
      revision: "bf3924b58341eb7a71785653a29bf26ca9fac95e"
  version "20230615150826"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a13afe5c7c1fe73c5b83e1736a1649ba4b86af27585c097ca6ad68e664697360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11213cec104ebec371892f53b8a6def73effc05c62fb6bb6568890edcf3f5478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0ea4012a02d142751530103f0d21f02d28f4491c92443d442a62307d8e59cb4"
    sha256 cellar: :any_skip_relocation, ventura:        "49586bde13b867da3e3809c57f0eb2d290fa491bf2c95099353ae0ad402a16e8"
    sha256 cellar: :any_skip_relocation, monterey:       "064ab73e75f1cd5c0c95c493ce7e7ce7c04f4eeb01e2b7637d2285fbd9e0cd77"
    sha256 cellar: :any_skip_relocation, big_sur:        "d96d823e132a00c3924c734fb27c24f9cfe7c1c1eb9e4267a355d51ea0bdd163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50f811c65f6a6a07e555da55507292929219c34a21bfd0a6ec391c0f075f10b"
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