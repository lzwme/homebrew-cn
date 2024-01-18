class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2024-01-16T16-06-34Z",
      revision: "7484802005d75b2f078be373afbbd44106f8cc4b"
  version "20240116160634"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca84925c87ce6250f3837c18b49c545a24fba7592ad1db349b7e18a3ac38ca96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eed908dc58b294781b42f6a5d41029e1dda8ff1ac5c1f38441301a493cfbbaa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b68c3ca4cdb3c9c737b31d62fcc91bc04817a6227de99aa38a12e9507bb21c1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "971844036edd1c1ce6b186ab8cb6f6ab65eef69d65d51813f29472371134ba53"
    sha256 cellar: :any_skip_relocation, ventura:        "3d47c2bab47a49ac0b9707b1ed240d7992f7cb49f278b1cd6133235573d8db69"
    sha256 cellar: :any_skip_relocation, monterey:       "1b700af5e6d95a634923da0a809b21f7c2b19b6477a89866dad2138644eb9381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e251d799116fdcaa0b26ceae7843ead1912895cc2ac8b277ae5712a08562277"
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