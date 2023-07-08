class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-07-07T07-13-57Z",
      revision: "e20aab25ec26ef3b1e44eac1f6a01f15f043ab42"
  version "20230707071357"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "569253924180632c1a22bdfbcd27f07ad89c79761a5a0f55565fe38b76f57ebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efde57ccd81da3577a51869b5c3458b8d9b8be0ffd5d018cdfba1e3c8a17c90e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d296c64c1c781bbd830e7e5d0ec1f8499b786ecb114f28c281c3a179fe58d21"
    sha256 cellar: :any_skip_relocation, ventura:        "6ca2af8f799a6fb37bf65bd8aab9255c497e281a91311d2762ec492e37c60263"
    sha256 cellar: :any_skip_relocation, monterey:       "30c373c6590abd595d68440ea6e6f2784ae9adf75bf5f848501b409a127a3486"
    sha256 cellar: :any_skip_relocation, big_sur:        "d17a1140518c616d8ca9bfa9e4e1097d35350729cc0908577de41b57686a8275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001182aefc81769c7409c0206325ef2356948aa58f6abe0332fcc9a22252e1bf"
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