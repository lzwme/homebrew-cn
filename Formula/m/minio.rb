class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-11-20T22-40-07Z",
      revision: "f56a182b719cb262e0628ef3f544371ea8842551"
  version "20231120224007"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bba45b95595910500397d81ccc1259bfa1a933cff4bd2f3aa67cf33020efbe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8399bcdc6f81980d13739ab216dfbb73a376cdf1253aa13fac039bc8db588b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65c78f65ce50bb4b01e48cb1c3ef697c887e297b51856935cdff28a6b83472d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "46e037bb93618f9f0a2dc8183f508e7e42fc1dd330a3c361e38db0dee51ec30b"
    sha256 cellar: :any_skip_relocation, ventura:        "28fb065c47915771d55e3cc6518a9ec076e021318a16022d36e1a712e5e2e559"
    sha256 cellar: :any_skip_relocation, monterey:       "340db4076076d997f24720f927fce6cf18933315e826c8f29dd742b2572e63a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b103e012d9b7916e7476c3ca2e60fc4c23322ca11bc7c00f728254074c9585"
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