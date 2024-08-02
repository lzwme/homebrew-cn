class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-07-31T05-46-26Z",
      revision: "a9dc061d847277e30c5c6918d6de6f0606f9d285"
  version "20240731054626"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "123a6dbc7465d2eab64f052f39ad5318417882e1b3f0f54dc3bee4e0974f635f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f209001fb74b937bc210b42ac7572123654543c4e33f87a8cdb472705e37a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "459095e7b169973a92bb7800e9532520bc7fa87f1de446d4a5995d5d9c96c68a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f4c8e490f9169beb865b09283923d57fb0d5e4134e3ee1e918b8f51db4eab2e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b7c30aac1778e373d9879f33a195ea943acbe28ab02837c6db13075d8cc172b"
    sha256 cellar: :any_skip_relocation, monterey:       "3345f51fcb5d0be1cc1885645a5031e9a1346233d0f6c1e992e7a24bbeec8dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc093338c3ae65dba64deefd52c75cf6a3930c360e747be865eb487541a4766"
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