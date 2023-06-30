class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-06-28T21-54-17Z",
      revision: "eebdcdf36501cec35c893d7e8ab7a7473ff6860a"
  version "20230628215417"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06f2babca2e4591eeb3e72f8274cfb8293aea81ae5b24bb2be36273f8b18414b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc746f399f1319fe584e980249645b0a6adecdce8c2ecb9a620c8faf249fe23b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c4773df88880990ee2ad6cdca954529043893895723640e622f03122b8ff033"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7e23f8194a4d0650ba0ef94c9122f57042136e4c002910d27581c9418814cb"
    sha256 cellar: :any_skip_relocation, monterey:       "d157b7bea7dff2e0df6ccc1df964f134d615eb2ea574bceb90ce262c12ac1556"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b64912a481f714ee598602bf62ffd06991827bd9791b21ec7b2ff0c45d9c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244630ab9443355a1feb0b1dfa16640ce759d12a0f2b10f3334c98540d262ab5"
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