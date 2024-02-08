class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-02-06T21-36-22Z",
      revision: "980fb5e2ab3674287207c9388bb8fda7a142cc64"
  version "20240206213622"
  license "AGPL-3.0-or-later"
  head "https:github.comminiominio.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ac62a7473dbee2e28bbcb84adaf0924e901137307943353a8562dc7afb65202"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d27edca9f6864be2079dda795ceb5cf440dd98700218561116c61f18d91dc5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff6affa78939f240161f0030b337c18ef0e66006c0300ff3df45eb6e647fc2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5addaa1b74f443e1957a10443daca6b446dfffdebb415cc03f0655b3260ce5f9"
    sha256 cellar: :any_skip_relocation, ventura:        "c3f7c64026777793ac3db4faa14fb38e8926876e8f08ee12cb44688944117cca"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab7ef28bca3349250aa8ef5f950bc759f265ef7349f41149f8057c5ad5b2a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6a7e72ea07ba7ab78a42e9e50ee55f9abfa791031515e4bf6435c329b8a6eb"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.comminiominiocmd.Version=#{version}
        -X github.comminiominiocmd.ReleaseTag=#{release}
        -X github.comminiominiocmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var"minio").mkpath
    (etc"minio").mkpath
  end

  service do
    run [opt_bin"minio", "server", "--certs-dir=#{etc}miniocerts", "--address=:9000", var"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logminio.log"
    error_log_path var"logminio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end