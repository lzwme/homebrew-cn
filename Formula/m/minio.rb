class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-08-26T15-33-07Z",
      revision: "1c4d28d7af0373cde810703839a179739dbe6f34"
  version "20240826153307"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0a8faeb3c4b01673dbad643a940a2819c19395601fcc163451f1635392d696d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4553ede1da52682c354b682ec3334bc71bc249ff7464ebd883ecfd96104d5dd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85e79dac97d84fcfc9d3d76988224ebd2c395ad2c562eade77b8e9d2bc884511"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b5bdf8fbe956cac45e38d1b768802d7494bb1cceaf0febcce31f06315daa66b"
    sha256 cellar: :any_skip_relocation, ventura:        "a5daad95fc02d17004bc0329161cd2252ce439228f3af693684d844741dd7d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "8aa69d4cad53bf25bf77777c91181e6ae6cd93b96cbc10dcfe76fbe49991dfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06cb7b2dd726a2d5866d13ea2ece6b659877fcda4c5bffc97b41e1a1d2685c43"
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