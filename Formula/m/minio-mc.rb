class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-07-31T15-58-33Z",
      revision: "f0d2ad47084cf1fbda8f955e9c6f4ee5d9c1daec"
  version "20240731155833"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "140c8b7f4482400214395ed18d095642914ec7ff9c0dc2c77ad7dc4f506c0334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c3bf9d4775271d75b498ee85a0b5f7aad798db030ca83b392193e7ba9e77312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8b2301a551e1f3a646b13e9db1d4f578245d76a0044fc01f76f07d522a43ceb"
    sha256 cellar: :any_skip_relocation, sonoma:         "340eaeb5cd610a5fd286d2e663e6d4218786f5b33a05980bde8366962bd645e9"
    sha256 cellar: :any_skip_relocation, ventura:        "4c142d7cf8a4c0aa95fa82c1bfb7053b0c4225becaad776721c35da410c7f669"
    sha256 cellar: :any_skip_relocation, monterey:       "887872b3191602abc216661bb4457f56479f24fdaee4ad31deb0235a5b441eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6e983712898d3719a33b8e58505f8aa48185ac865b663f5c258504cecf06150"
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