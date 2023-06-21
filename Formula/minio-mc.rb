class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-06-19T19-31-19Z",
      revision: "5f39522e69025bea6be0d350b65fdec2de2785c8"
  version "20230619193119"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5e82d038923fe3852bbdf505fffb557ee4b44ad99a7057cc61f8d6d3cb610f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f364b33f159a9a825d00f2c5f60061c8c21730ff4d2745b91da4c52d4684db37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f0eb55ff10a217dbabb3df468ae62e1027cc0bea09eedab7444b47151f7f8b1"
    sha256 cellar: :any_skip_relocation, ventura:        "d3ed2ee9e802d4092b90c6e27283b4086354398a637e203c7c401d9e5be083de"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc96a31100ea966e4d32e04494232a58307faeff6f31eaf19276f2df0772d7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24b89d7573d000a1f48ed3bd12f7c2ff61221a6ae2590e59f78ca0879fa4b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a330f460cb572f290dd8196414b1e98c8af9388cb22b9144d9f9d913f89df97"
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