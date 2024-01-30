class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-01-28T22-35-53Z",
      revision: "7743d952dc16ccab26ca9240855089535e548062"
  version "20240128223553"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39bd998b694edc8d1f9d59872796e82d78441d34c32fb077af03c684526461f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80e162b613a695b047948e77f21a9f4fd2bc2ea051f0df501638a87a15ad5cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e095f58b681bddd7be9ee345ef969a17a7881d811e0ee5d3a4cc964fcf58f2f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bb9c248a9a6f4b98cde04814623f7e2670304a7fca96e903668646b7f5cae61"
    sha256 cellar: :any_skip_relocation, ventura:        "20ea01fc1011b994c944da41f81ceb1146bc5047e69275be6b6a2bc0e96b38d8"
    sha256 cellar: :any_skip_relocation, monterey:       "23bd46e2452f805f29ce2e876e8ca63727aab9e4c9a2f46ea5a645730a9b2826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a946a2a29fc78cf69efb86425d1aaec104ee29c5311701cf1094accb965b423f"
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