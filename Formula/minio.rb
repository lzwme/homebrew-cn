class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-07-11T21-29-34Z",
      revision: "9885a0a6afd80ad5669297ec750cdfa05126e674"
  version "20230711212934"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1485e8c275e7ae512450c1405aa18a374eebdaf838a82b72a1dc09f4b14cc17c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b226c7389ef01ddbd9d785c3eb1ab2b51a61de48948bd35ec831afffcee7624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "341d6540f66139ccaf9195629c2aeda959341ba87c9548470b9b50247b5bf01a"
    sha256 cellar: :any_skip_relocation, ventura:        "be2289ab5803f0aa17f98d3e973f3d55e1d7f10bb57792ebb5e7c72e75fdc12f"
    sha256 cellar: :any_skip_relocation, monterey:       "fa450e6c73b07944b218c71cbeea5558668c145bced635ea0351bd1671241fd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "067af19d662dd5a7aed2009e58af41854132da85a310c2795902302c1c75dbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b040406e481acb7d16fc2dc1508c1703e5ee7b75e9c98d24e74a907bd57483a4"
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