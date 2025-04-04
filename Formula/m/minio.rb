class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2025-04-03T14-56-28Z",
      revision: "f2619d1f629db75c4282329352f4aaf79caba436"
  version "2025-04-03T14-56-28Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https:github.comminiominio.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0f86360a6c75ac4f404da618d74326b947b52adf160a11b28bc96a8bef9046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50bad4225bc5d0e636c12ea89e42709e6c669aae82897fc72a8990d42e5964fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dbac9b4235209ba9aa4659105c381a6bc655ecddc6e054ed9e34d7f267f25e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "754f4c0ddcf2cfb9c79a05317c64b293dda765957f72764b309b71404ff1ca28"
    sha256 cellar: :any_skip_relocation, ventura:       "85b7d23b3a085b35128785d7721be2bdb404c90e942e8be52ad2989fc3ad0eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2fdf21d13661dd7fcac61703a99ddb7a578d3c90cfc8b9cbec2c6606823c0db"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.comminiominiocmd.Version=#{minio_version}
        -X github.comminiominiocmd.ReleaseTag=#{minio_release}
        -X github.comminiominiocmd.CommitID=#{Utils.git_head}
        -X github.comminiominiocmd.CopyrightYear=#{version.major}
      ]

      system "go", "build", *std_go_args(ldflags:)
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
    output = shell_output("#{bin}minio --version 2>&1")
    assert_equal version.to_s, output[(?:RELEASE[._-]?)?([\dTZ-]+), 1], "`version` is incorrect"

    output = shell_output("#{bin}minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end