class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-07-16T23-46-41Z",
      revision: "3535197f993dea840dcb96302ba4d883dc619097"
  version "20240716234641"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b71ead64c073075a6ac60932adf33d08b801a51a7b969e74dc3d1bc7e7a2b4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f90d9cfdc7bcdb44de89161254945827ddb96ff9bec481488e58438b1eb8dce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f61d1c0db239bd26aefea801eafef70448d7f4c5f4c677088820200a01485a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18ba37f2423c04d745f16faf2c4a192acb420126240d2f2ea8ba2d03bc611cd"
    sha256 cellar: :any_skip_relocation, ventura:        "d015f710017b40e5d06ae0c0a87b74bb863a143414eee27e2e685d94ac83be30"
    sha256 cellar: :any_skip_relocation, monterey:       "d06dbf61c75fad7d52a10d6fd21786976d09867d6a9101bf8eb3829a8e284933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b291db0bcfa4e9d7e25deb48551ceb6df245cad7ab2d252bdc9c5c34fe56c27"
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
    assert_equal version.to_s,
                 shell_output("#{bin}minio --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end