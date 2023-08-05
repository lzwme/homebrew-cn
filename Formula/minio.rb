class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-08-04T17-40-21Z",
      revision: "cb089dcb52f0bc8eb58a4c991dfd92a0fec13e62"
  version "20230804174021"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02834eb52e20ce52e4b02ac7b5e9f799ce07081276cf559382756221f09968e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed629852f8ad456490cb1082909978bdf465922be580f5206f28fc08dcdaf78a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b93bd5fb0d1c85045c202d12a6b1675821b754d282ec84b406263bf39059b5c"
    sha256 cellar: :any_skip_relocation, ventura:        "01b87fdbf377a7b66620432cafc1b2a0b84b5d1372eedfad01b0d7015de2b059"
    sha256 cellar: :any_skip_relocation, monterey:       "83c7a57850bf990b6be5ba45925cd4b0b27ab26dc0e61c1bbf25007eaf849be8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f44fc83e2b5b1dc8dd342ff6fcc3ddb133f60b493f208382533197ecfd7f19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bae2c24563a2efcc7b38fc05b2e40799bb4d604f687d5e107623bf63485ec4b"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end