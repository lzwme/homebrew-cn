class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-06-26T01-06-18Z",
      revision: "499531f0b5863ad5b3a5e92a24239138c3ba7a13"
  version "20240626010618"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d473f16d4bd73901a47ee844b08b0009a3eac19fa2bd1e2e93d777baea7f1bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5b02e101ca462b5f4078294781671b7a0cc3ddfac8a99d198b643c2e9234467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b12f4fe9ae93f654af93a71849cc8a6eb1b843b94b519c0749ffd1c93f74efe"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ed63e347500b3cbbfc87a22f5249dac8594967d6c1c697ec991c6477ad8b6e7"
    sha256 cellar: :any_skip_relocation, ventura:        "addc02835337542c98864eaf5873b32f935ee1a8e0f428899ab2d8e58f903389"
    sha256 cellar: :any_skip_relocation, monterey:       "df301f083a0c3f5de6806a20338c52fda5533fad1ba30f6847b06cc0708a2cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c99b0a48c68144e8a36c709d5db3db6b196e0c8de525d0f8066739fcb78eb51"
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