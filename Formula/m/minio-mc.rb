class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-02-14T21-19-52Z",
      revision: "6bb045a5e67f10fe66053195c4aac32744ad9f18"
  version "20240214211952"
  license "AGPL-3.0-or-later"
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ac7dee3a929bcbbf01f366d5a1cda28bb1b41aa57f7c7e69f43ec7f17593cf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cef54c920a6fa5d499d080981ae7bb55efd06aed5f9806bcbd6c53bc30ad15b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "812b724674263ed98a275511b0b9a338f8826007b57614e277e6651b0caea7fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a1bc6f2535cf419d5a57c395f312e85a80ea8a52a2d4a23c20ce67b76188dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "db1e7ab868890f5ee693a8a2c6229ad784ad9d286cc88fe4f882a6614f628be2"
    sha256 cellar: :any_skip_relocation, monterey:       "59d600c85502f3c3bf2dde9ef603734bd5ec7559ec6650e9886e2a77338b0de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03cdc46b8ab91544f33e91c5518fab1886b525779ebd7e7e30a06f7814aa203"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"
      ldflags = %W[
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin"mc", ldflags: ldflags)
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}mc --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end