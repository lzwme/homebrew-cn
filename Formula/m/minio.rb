class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-11-07T00-52-20Z",
      revision: "cefc43e4daa4cbb490ef6726ea374e26a93eb85e"
  version "20241107005220"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e665ef6f4ec2cec6d9e2f8bd2dcaa13a40ab5c0f865d7585b79b98b0f7246639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eebeef162a81e90b5d2674589b7dfba0d66eb6bb97501ad665ecb92595b542ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e00d1657af005c5d4f9383e4f033c61d0d0158c02a95470573dd6c6ecf705fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d733ca281d4d63b985f7df472a53f6a24d0ac582ddf34de0a79c576ed9b19cc5"
    sha256 cellar: :any_skip_relocation, ventura:       "cde3114019797895619193565b85aa3e0decb6a623d5c66fe683e310d0071645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4686fe47ee23a12f100de586777c96160f80c350ec534fa69a5a9a073f0f1e3"
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