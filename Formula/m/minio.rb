class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-03-30T09-41-56Z",
      revision: "cb577835d945dbe47f873be96d25caa5a8a858f8"
  version "20240330094156"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b048a2a5d53624bfe27e852416d393e86638429b455446b3aecd7a5adffd315"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26a4a1004933ec68239dcc775b12cfb2a3784bdeecb21150764828b7365a564b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fd8d17e79a61d5a2d035f449c2179da2813fb8768835a7d370e499a8233f3f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bf04ba16c6cd1dc8ace7c9bfad11951e1f4e3d021fe00162c5e9286f6715891"
    sha256 cellar: :any_skip_relocation, ventura:        "c9616e6f43c40c4b6a51f9c2dc7b7d5fea5cccd883ecc4fe71b263338d7b99ae"
    sha256 cellar: :any_skip_relocation, monterey:       "965e815c1d8c19132f24e26371dde547382f056c790e55b99e5887e2598a56b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa9b362e8e0c5a0e054d90ba26309e96f86afc9a63e5fd1ca49a2387e4579c9"
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