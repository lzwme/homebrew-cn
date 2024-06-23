class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-06-22T05-26-45Z",
      revision: "be97ae4c5d6f79da250632264602997d7c4f2e86"
  version "20240622052645"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa27902420673717ab1f8b49590f08e3693df1dce0e0ee357fae9eb98b996c94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c51dc2e94bbd8659c17e23145fea977f1dbb54449f7724cce961b8a4db9be75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2aae210a490df8b5aa6fd18b2761685fc40b487132e29352e93f56ae77069d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "32a7ab5a79ff4b3159819218f983565e4043947caa13170bb4a7bd23de1eb718"
    sha256 cellar: :any_skip_relocation, ventura:        "6369d753bb3cd90fa632405ab80b90d59231681b9af251125ca50155f93273ba"
    sha256 cellar: :any_skip_relocation, monterey:       "652c61043dad392b1d8681e612d68d8608d5e6ffeb28084b738ecd7a1d0ecc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8146037b29f4848c0b66a35e976c05636c374a9bb3557043bba8626ce394f7"
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