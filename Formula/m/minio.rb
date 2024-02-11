class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-02-09T21-25-16Z",
      revision: "997ba3a5742cd0ebacfa109cd93faba67e4c5036"
  version "20240209212516"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "150c3f271110592ddea228fa040b63d4efba3e4fd77b0554d838c3c40b01367f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61393bc1260aadebfd87430fdfbdc05d328f6ff7fb9e438304783627a865c029"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "241738483326d44f4979c103c81c228b5bcbb7f39eefb85784008bfc0a9c08d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d98e15477c84157daa835320f7038b8e374f33a3de5b5efa525f723716566e96"
    sha256 cellar: :any_skip_relocation, ventura:        "69718dcb142fba3a96537bab3a7629f12457096830eb484c0b39903e5fb547ce"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd2d72cf20f597f307e59ffa335a6dcf1a615f3864a7fc85cceeec8087f239d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4aaf47eba87d0a6b83c37538874bcc2d6c678ff4fc7bfec6a8e111447af42b2"
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