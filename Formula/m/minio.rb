class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-30T07-02-29Z",
      revision: "22d2dbc4e68a20ada8c82edf1cc68026e7b0e3d6"
  version "20230930070229"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64cc5509d921d8fd99b0a975d96a929aad835023159a7d4e91ec3ee6cc028817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e3ca8cfb4acc4064b219a471c29f450068f372de6a3f9ca09800e1788e6df5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "303bdd3131f503dedf1d2f4efa290e08f675f79171fa3e7ef5c942d6334aa9d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7e546142fc8c59cd3b34b92b8f759784727b8a5de4a75ba681bf06749030764"
    sha256 cellar: :any_skip_relocation, ventura:        "c39bbd354b40be69ecdefcdc2c60bb145f4c9a335999785841cf5d2a6db0b8b8"
    sha256 cellar: :any_skip_relocation, monterey:       "e7a8bc66685c4bf05363ee818591dfb594bbc950f2d2c83ce85c61219aa0465c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cefcfe8ff1174f5f95d50bde66a5449f72081560090b01d48b5d6ffc4296be30"
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