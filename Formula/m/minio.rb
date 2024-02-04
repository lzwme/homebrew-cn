class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-31T20-20-33Z",
      revision: "24ecc44bac566b25a5bfa9772d946a19ce551035"
  version "20240131202033"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b5f44f42d1507fc6d210981e07912480d8f999c6a7158753f6fc8eade781517"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8b86892601bc2ef37304fef4c304fcb02b9e453baee078e7af4f4927bb6863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "098018d2c960a4f25361b0b19468b7a8b7a412dd49dd5d5135106c6821ef4cba"
    sha256 cellar: :any_skip_relocation, sonoma:         "97ca353be7c5ec7750f4c997fc016fbe3beaf8910ab8ab437910ae9468d6d0ab"
    sha256 cellar: :any_skip_relocation, ventura:        "b5ffbaf0f5748ededac652c4a3c31f919e1693e544b5bc520aa5a1cb4ee50f31"
    sha256 cellar: :any_skip_relocation, monterey:       "352b4fcc3cd8073ab3e18900ec3e14f7de44a99d4821b8612390ea187a3b7249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135edc4c494f3f60b4ac8d8bcf960f9ece691a670c95caca77d3d9744aa87039"
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