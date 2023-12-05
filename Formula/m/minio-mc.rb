class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-12-02T02-03-28Z",
      revision: "f5f7147b9ec4cf78eb67f1cdc91b63d191852e6a"
  version "20231202020328"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7953ea8aedc53f7866a55510c6619e30acd970fb1658a4a337c773254f68ad80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deeb49443b007d76fbe201b103307805182d5ac4c09204a0f95538e46269fc77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef389edaf7ded37593bc1c4f7c46e864ebdb1af151038d677414843e7a4c0ef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "82422765141d01ca42ea9512d51299c839d2fe47f9492d4aa77dc55097b4b651"
    sha256 cellar: :any_skip_relocation, ventura:        "e886ba6023f06f86ba5823b924866c87f1e9cabad08d201c7c328e45cbdf68a8"
    sha256 cellar: :any_skip_relocation, monterey:       "0f37c439103f72cbb90c662a5c88c950afc3000517ebbe1d3308ae5b1a76f432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8b5adca0f5085a006dbd5803363f3bae111f33035f182586a8f190db22cd92"
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