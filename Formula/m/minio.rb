class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-11-15T20-43-25Z",
      revision: "38f35463b7fe07fbbe64bb9150d497a755c6206e"
  version "20231115204325"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b26aef9e80012a099ddb5b855fcf529f06f067e1239febe403eb869f488ab9e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1c1509fb524eb1a0e4d6cb2346c7ba42502f6c0766c1e812962ab85c641888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afc9781ff690c8c1221b73005245fa69c66d0d4bd26d8cc9fc327ddc16627502"
    sha256 cellar: :any_skip_relocation, sonoma:         "bada6b04dea56eb1eee06533dcfaafff5970ecd93e212b9b2bdcf4731db13be3"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf08ae3c59a0ce38a66db6853d4127856696dbdc63cf0862e716a3ef8d15f16"
    sha256 cellar: :any_skip_relocation, monterey:       "f8a461a6a6b1b6a9b4ef84e03e00899dc00ad8c1ad3d0becb598ce3fd34511c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95c3366182f7a33cfef1527fe9fc7b8cd460b1863da3562046e9e989de2077c6"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end