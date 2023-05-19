class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-05-18T16-59-00Z",
      revision: "43745a9a597547f6bcd381b63b2e3c509d9c51ac"
  version "20230518165900"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0485a8b21b1afa0fd90735d544d2c67b139b9afb174f9ef17fe51165f50899e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb014cf09b6169ded2465a913be6bdb813753359a2bdb8fc7aacf6e28ed8253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "198687b98c9f6542d1f2c37837266d5364419ee52d10d2e39bf2db4d0409cce5"
    sha256 cellar: :any_skip_relocation, ventura:        "c50ff968077ba053c68dbc6abd8ec23de6cff95cced1424a255442b23b5cd112"
    sha256 cellar: :any_skip_relocation, monterey:       "e4eaa4d3e0deeaab22e0e2660d9d6b9690f4cf6c2bbc040381805120e2bafb8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a5eabdb632a9669a5399af9af64795e9837faa1e79ba1992d0f8a7a8fd5a788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a78c4fdab845f44a02425d6537cbf54df8724fe5bf6b89fef5be2313fad880d"
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