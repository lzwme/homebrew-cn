class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-06-29T19-08-46Z",
      revision: "f5b325d9d399e09b4d21384081e397a52f6ca89d"
  version "20240629190846"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78daa656bae21097996941c995b10f1368b7a76305e278acef63648e63a62bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc4027d216b451d8d5bdc0c4bf292b37fe53d4f6df090f50abb61721101596e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d147d3c61a081926b0044fb112ee93043b10f049b04405bfb2b2f9a92ffff7"
    sha256 cellar: :any_skip_relocation, sonoma:         "af3b7f241dca6a8f95e2954123d596f910f5030b23f46ee67f3bc5a0d4125a54"
    sha256 cellar: :any_skip_relocation, ventura:        "caba3ad7f2a615c4f9e727cb54ffd52e7c534de819f9a89fc3cc4287263c1dd2"
    sha256 cellar: :any_skip_relocation, monterey:       "48471de5768f8b9a9681086666e5b79ca3acccd24bcb8946bba2ac16c7dd4f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010237f57fd94e25b1189ee4325954d06b303b1df40c00962012829a18955dc0"
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