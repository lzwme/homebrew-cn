class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-03-24T21-41-23Z",
      revision: "74040b457b50417b58eae7cb17c63428a0e2dd44"
  version "20230324214123"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "978deab2042b7cbf9a511e18c83e8f2830f8b583191b2c7dc62c3d9076c79591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5466b6961dd5840fc1cbdda6db05b2fccd552bcc96ba10875fd210e89f28a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3044276ace80aebd0c9f218a354b3ca5d4f76782db3ded95d9cfe4bcc90796c"
    sha256 cellar: :any_skip_relocation, ventura:        "2e68d0586362792a78fa31530f9c8edc5523a5e83762de2414a1275792ca868c"
    sha256 cellar: :any_skip_relocation, monterey:       "046a2e7411b14cd030a3b23e292098a61125d09047ad56cbeffc818eedebddfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "585aea34f79262355fcdf90b8349eca1a118c85155d07f8693c92754252adc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c233fc016bd4e2c6042064cc18edcf885fbfc0670ffc620aff8f3d929d0448"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end