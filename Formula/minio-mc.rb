class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-03-23T20-03-04Z",
      revision: "81453d7c8fcc7621f976cfd8e8a72e78f4d243c7"
  version "20230323200304"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25bfb4b991bf0a6eec0900009f6177e78587481ce5dc50fca9690a2c7b532ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a08585243bab6c1ae1032253f29fd2665a658fea6e99f753dc4b1bf636a4a645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d1fe242499bc79c9434fcced34f2ac527b5a8b4d5c625f4d545934428c87af5"
    sha256 cellar: :any_skip_relocation, ventura:        "3878af4f88e34dc3b4327b2848c10162a6a2ebc8d69a4753bf378fe78b7ba314"
    sha256 cellar: :any_skip_relocation, monterey:       "7c4eb4823c6ef711be829ee59b9abfc994f1770d464b11c26d8bbc9b216edf50"
    sha256 cellar: :any_skip_relocation, big_sur:        "d45b63fcb2b8ed956fc0e6d77a82b48e54586aaf27e7b10388c1a2de75d9e388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a49e7fc1bb6d799c56f108629acf0f205d859d534b90ac7375246c8f009ce1"
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