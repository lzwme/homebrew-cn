class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-28T17-48-30Z",
      revision: "103272612aee8ae1a3256ede90e2190111069d51"
  version "20230928174830"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ad02059481694044d61c479acbd6be386dc4b524feb2fefd828cf698f55c787"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d46ffb6b75ddb6a2f0f86d8ac416dcc06400ec123e21246aab9454e840af95f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc9ae8ae27ad17933cfa584bf79e588b711cdaf451b58e02e0596855ad372d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3203b4eccb0f1f07ebe13a8ff83993c0d1564f2fac5cc2badd7c59a5c9e52773"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7dc44060629904c23827a710410a028db198aa7b38cf6e99868f8dfc286518"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e8f0161ecab8da2f84a9c2c4d2d1ee37f8687d587593f4310ee549f7f9dfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af985e27aa2c0076e9f90c5eb0267e3aeaabcbacbfc4816ef70500936e199e77"
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