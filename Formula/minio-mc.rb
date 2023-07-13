class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-07-11T23-30-44Z",
      revision: "c1193fc29d61d8aa69e3725a519abd95ee9da910"
  version "20230711233044"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "489c1b043f24f443cb871200a556f79356555e07f95a1c9c415934e6e9ade3c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8858fd2c9bee805b82a7c6ff00959aa277a9c2723fd6a5bf9131e0864bcf9dad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c758544a0a1379c2f27d920820f61350fb6ec7ca74f6f15afa5e1b74c0074b25"
    sha256 cellar: :any_skip_relocation, ventura:        "3d2238f06000a67234fa434933938c3b7f38b556a6d22c397fef49edc2d87df6"
    sha256 cellar: :any_skip_relocation, monterey:       "35ae7ccff074ba943b99d3aaf8a1f2fa2ac7b765e386f41e4d380d4df79b193d"
    sha256 cellar: :any_skip_relocation, big_sur:        "11a5cd50cd0201425e56163c42029221e58a24a136f91719221a623880fb1213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a2cedb019a1bc2cc816f207cbb406e4a45ae495c843d787c5ad12db53d4328"
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