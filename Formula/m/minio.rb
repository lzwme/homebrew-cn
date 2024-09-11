class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-09-09T16-59-28Z",
      revision: "0b7aa6af879e088030d63e91a29dabf22fdd3a18"
  version "20240909165928"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcff3bbb98cd9b25c118340acf2e08f79b6d1ae9bb6ec8fb01f4ae693da628fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce0b80e5935b336c6c01c2c8374691ee66c5447ecaa9f8033ec671ddd23f2d39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84400fe3ad5ee86208798d1622bf8b62b3ebac76a03cdb65cdf015b74d30e53"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d03f4582e851415b1fa985e6bf58de64f5272f595af79fbac41936b844416a"
    sha256 cellar: :any_skip_relocation, ventura:        "b4fd12bab83cdc5af1e468e0999b09a15626e88b9acf682ad5c6379ac0880ff8"
    sha256 cellar: :any_skip_relocation, monterey:       "3a8a33bce6a9798b42c80aebb087d62c8f41cfeb941c093befe643a7f02efd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dcee9afffa008e67ccebb27d6c7fdd50c218fd1310ea1db5cedd0653dad1869"
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