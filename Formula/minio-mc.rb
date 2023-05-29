class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-05-26T23-31-54Z",
      revision: "9cb069e7afaa45c64c45b7b59ba65c0441019efd"
  version "20230526233154"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0064eeef31b8331adbfd1bfc848f8b01e6c012be44de6c38fb1870c8fc66da98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f47f64fd9a8dab0baf636c9e37968b1582f7250eb134a28a3a9734052ebf236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b90d67c43f1e7f6411fcd1790f1933b88836a4cc03778b49c2c2fd28310ce43c"
    sha256 cellar: :any_skip_relocation, ventura:        "5900c2c4c018f64a87c1e3c47063a2225635500d52a9d1d92ad8ea52fa1b5507"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc72eb3b8e8893f7b9a4f3326029515848c3260bc39f75a19cd0345565c1da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb898e02cd0f4a50ee056fa59318e0977e54390bfd4216bc4f86e04b82b2d0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c0e4512ad6c85e739790635d9e73db17e1e62136f68544e35dfcc96b567143e"
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