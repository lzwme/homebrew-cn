class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-07-18T17-49-40Z",
      revision: "0120ff93bc4b9cfaf2865e55850e9b20e5ef703d"
  version "20230718174940"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adfd13ca3a1e3544c551d5207f6fbdc3984d7d6cd6744407a337416c2ed97f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f665e8bf15e8e3e34868462223b2a365d3843b665cf5e3b1e0cad6c1b0f66e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d25c1c1cdb8642bbb87524f4429fef214691ceb49339e2b2a439891a29668e6"
    sha256 cellar: :any_skip_relocation, ventura:        "831973f85d8080d576805f4f07e3c06557d8718d61dbe0fbdf038ba07238ad12"
    sha256 cellar: :any_skip_relocation, monterey:       "116300e165f0770de2444e631972ecb5076678175287dc3d54c5fe5045b3d949"
    sha256 cellar: :any_skip_relocation, big_sur:        "dff4ca104c98ffd00c623b35d68f13b9bb640d497094755c7d08ee513d711b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec754458eb78cf760a58083549ef51a6c3f17c4adad06caba2ec65eb26198cbf"
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