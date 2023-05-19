class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-05-18T00-05-36Z",
      revision: "9d96b18df03f5978873705ac55959161f018fb48"
  version "20230518000536"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e237059119b5b489fa0fbbb97e6b8727fc9049237e8cb59a40394e04fb0a8ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "765a809abc5bd172c71e6b662dd3ad949b76f77bcd5bdd8b5cc2c322f7a05bd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d76ea39db23443ca09e017a32ba6def5c9e44895f2105bc03987c67372598f9e"
    sha256 cellar: :any_skip_relocation, ventura:        "e0abc64a317fc6b8eeb39ff83251704ae25dc31c9cdca6a61de1b8b665cdee3a"
    sha256 cellar: :any_skip_relocation, monterey:       "941f2eeefbfdd93690812cdfe2dcb6299b740f633a96d5b9c5ad0eab140c2a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "80e59f2f66c61da82d5c1e0ab72a2bfb444ae713e01e3cee6b76a6f8e45e2aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6a166138ddc29cbfa277f89407d63fdfaa4bde8be597d961070d452aac5dac"
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