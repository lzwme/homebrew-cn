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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aed8d2c11c8ba43e2cdfa0e47e8b943de7eef9df855fe14e96029f620552933"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a976926d6945fe9b846926c3823ec2a3e396dfda54eb29461c8256b8eed5fdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6abeab00d3f0a2f028da87da5678d25b00110998f28b5ea51973bfaac2c2f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "89a40925a12ca5d60841a678e87fe19257de90abca6b8ef7cd828d00f9f98dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "c9c42c9e23e1bbc45626638869a14ef058cf503e106af5666c948ada0e7aea32"
    sha256 cellar: :any_skip_relocation, monterey:       "b341c233e465a3fce9d88b6720901cb903fa7a3e7e3b1141e6eec8dc6271116a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5243b923c7937768d22f6e265ccfcc942d2350d02c35c1690cb055491d75e2ea"
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
    run [opt_bin"minio", "server", "--config-dir=#{etc}minio", "--address=:9000", var"minio"]
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