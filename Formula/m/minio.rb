class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-07-18T21-56-31Z",
      revision: "4021d8c8e2ef026aeda624c25ff3fffdbd112b09"
  version "2025-07-18T21-56-31Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecd97b7cc79deacab1e3a032d231641a30c9a0ae5158e2db0f974a3e73ba9403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc6faf2ed8baf01bcb9d2a52974772b34e6602bf9192526e1506d588aafd9ffe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "174b0e9e642c5a2654f5ae42f3b82f980616ba50350dc88101437aefd48d0f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a6bfa384574ddc97a3737e18a050dde4a8d26aaae67f40b4b3dd4cbfa7003f"
    sha256 cellar: :any_skip_relocation, ventura:       "e5465af094058c823e163b6fcdc40ca96514e6adf1e75b34f0203ad58f8ef3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8547fbcd5f74007833698341a4432ee87ce38430520351d624a062032be139a8"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{minio_version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{minio_release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
        -X github.com/minio/minio/cmd.CopyrightYear=#{version.major}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    output = shell_output("#{bin}/minio --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    output = shell_output("#{bin}/minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end