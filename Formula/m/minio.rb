class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-07-26T20-48-21Z",
      revision: "641a56da0d7fe7e86792f1108c50ceeca78fc31d"
  version "20240726204821"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f70ecc6200996b74f482322edf9c707b2ee63699020d11f868a8f4440949221e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e7596b3c614a375ea6755ffd69463a2bf1185cf707fe35228d35cea490c812d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43a9fba6c77667fd356bc586591f3b4731a315da83b63fb8029201045a164239"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7fb90dd81680229f97d147028c859e67eab00a1baab27ceacb50b1348ac02f4"
    sha256 cellar: :any_skip_relocation, ventura:        "ae6c8b278b6cf58bfe89dac28955b45898c32dac11fce5c3b41f1fa1937a4980"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b375e5b6a886c7b88ba8bcb746872a204d3386e4406e189d9ac7dcd247e3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9247fe2f428168f32a3e9a33f009ea677a39f28aed3acfcfce26f639bc1528ec"
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