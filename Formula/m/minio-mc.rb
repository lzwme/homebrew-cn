class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-06-01T15-03-35Z",
      revision: "3cfa8642fdab18e3c1599360be26167e377063cf"
  version "20240601150335"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93bddbb2ec8361ffdadfd209c8725bf7358c63c5077bd12d1a0398ffc4136c65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "507e156647db681c1185553efc449e3af74e68942364bc47baab3ee33e0a6fa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9940125fe4b78a588238aabb84abbedcb66c8aaca2a65f33cb7a898d9897b3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e24bf7c6be1c22790481f4166756bf029424a928b394721a9562b43e4e8f7425"
    sha256 cellar: :any_skip_relocation, ventura:        "b7fd40f8f631484a009c7b1645ef82ee902f27154ffa1dbfd88cf0fc31dd0bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "c7682090fbcabfc592fae2c6651a4a7d70d574bfc711862debd29c665e2077f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf73ce0c8a8d806729913267b3244305d01d272ec265c7524d4668d4363bdb3a"
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
      system "go", "build", *std_go_args(output: bin"mc", ldflags:)
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