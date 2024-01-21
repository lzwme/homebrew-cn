class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-01-18T07-03-39Z",
      revision: "bb25267eaadc0e025243b443a94ff33bde6302ad"
  version "20240118070339"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e515dc2952b3418234db43d5a9940e596428aab54d89760d11d8f5a09464ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d21c543c70d3368d64dd7e28b2432c22fee48005641a9e27f7b2873fb892d8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf46c5dc8b4f9a1b2c88be6367f010a641828362f2967a108af6cd120806d7cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a00ec8e750497cb36abc40c5597aa64fc09a50a668b421c473fde26696274bc"
    sha256 cellar: :any_skip_relocation, ventura:        "2ce42e5a85e9b6d8befc57268adc311336e4fea27c1aa5b574c13a1ceae1d2d1"
    sha256 cellar: :any_skip_relocation, monterey:       "f664f767e53ac823fa23c5c028dc76094cf6ba22604f7b77008d2bfb49859f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a7679b92a1ea0b8b36f8030540f2277c1b355100b544c1d898403c996a6183"
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
    system bin"mc", "mb", testpath"test"
    assert_predicate testpath"test", :exist?
  end
end