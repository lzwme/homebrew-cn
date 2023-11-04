class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-11-01T18-37-25Z",
      revision: "4b4a98d5e59354870325ad19703fba03d1b104c2"
  version "20231101183725"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb73f8e549ca2ce182e083aa761477fa49ed8adf02d8f69b2ce32683ab94d603"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282a1f2ede2d1c1e0c449fbdebf853b0c4cd5bdba43ee9e141d4e65ca4d0271d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a15857f2ccd86bf4481eb1c2971b48dad1aee88dc25a7b4c4de15111884a1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0bf3e2af571c919e77c71b8a1b4b747e6c77924c06c094738dd318338b63b00"
    sha256 cellar: :any_skip_relocation, ventura:        "41baa921a65a029f956fae13ae1074855d88e95fd47f78216388ee3778c60910"
    sha256 cellar: :any_skip_relocation, monterey:       "94fa074e2f69b1c8bd5e0bc353e29f0ed6f06708fb5b3ecba9506a9b9dff11ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94611d6e02cc41a7492b10d0f4e900380924f8262fb2097950382d2cfd5f9f74"
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