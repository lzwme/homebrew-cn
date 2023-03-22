class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-03-20T17-17-53Z",
      revision: "88896ae495128646081d8f809b8934c74cb90194"
  version "20230320171753"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13866c2458ed01d5f37adac16aebbfa1ea126b64f2a4c6b68d8f9a0656f57cf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48008bc94b60dfbbe9a142e7c265738f823f0c2c0c06f13e0e6bb1f2c189b3ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "146f32c80878c53bd1e4e6fa28593cee2d06148cf038c15ae8e93867abee3ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "dadea4c25e4d59dfbdee6808ca9b9465043c18df4f0035fd2896782696f87673"
    sha256 cellar: :any_skip_relocation, monterey:       "33e0813f714dc5ca2a94b1d1f585449f550a03bdec4c792477e517d2232135da"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9b54915b9fe83dfaaa68391a0626775370f780b774635fddeede922d94116a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a1f8d7b917fffa85e3dba057771db39891466f1bad2556ec8f2bc536a37684"
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