class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-07-29T22-14-52Z",
      revision: "2d40433bc1219c845481f6311d7a13477d1c1f5c"
  version "20240729221452"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4618ac9df47b4993ff73eeb70539e2d1b62284667f9bdf45c77dc4bc06ee4699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e84ee3dc5cce74e21d6b29424ad161f468350af7f06834f96e9e9e325d70bd67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a84a34934034b9562c736d5f2d4fe922f406dfdb053f70a5d3f6f5d48608a348"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfba1f7c67af441ea2cba82ed5fff352da5c1d0fee8a75f0c7224ac86d454f20"
    sha256 cellar: :any_skip_relocation, ventura:        "f280033257e21d42f3e8e10e41a9e3e53926b44ccd61add0ff402ee25ed76695"
    sha256 cellar: :any_skip_relocation, monterey:       "147fd52012616a269503b9df0ef00e4cad46776a03c712a348ecbeaee7891914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f6127b30ba3d3f9d9abd4726f72a89f90ed77f2a57a69cc1847188455bb1ba"
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