class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-10-24T05-18-28Z",
      revision: "97cc12fdc539361cf175ffc2f00480eec0836d82"
  version "20231024051828"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44ea7c5e95616c9238e6f8944896e747aad5400c555b545a5bf015b0c1a1ddc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4bca5a847422a24233de36fa1cbc6eaef48a0dd62465f8ff623ebb8bf527a9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f503247f9b61e404fee2963d5a45f5f47be74ea27a4142a40b56a8e6204fef7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c72f71fe59da9bef388df4b2b7ce9a48fd38fb700e14bc6f85062e8829641bd7"
    sha256 cellar: :any_skip_relocation, ventura:        "c38112ce858a490ebda9b1b25b47ebd6f79f02de06a7dba2ad6fbc6f4bdb02b0"
    sha256 cellar: :any_skip_relocation, monterey:       "244d28fac9e2cd6e3cba0c3e4d168037eca481ba7f37a1262be18b654ab40fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224bf08f04896af730185e726c07445ee0608ef093eb22089ff68c48d4cabdd0"
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