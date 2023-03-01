class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-02-27T18-10-45Z",
      revision: "0ff931dc765d5d8fdddcdf7687fec1b0b194fca9"
  version "20230227181045"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4a155067f27723167048c489599f1bfd3d76d9a1b0731709f2173c233564635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a792205a9d92986bbc7e4eb7d2621d10d40d94628ef7b8aa7aa7542ab21e629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd58f38d9cc50a1b6da90bf68b638ede01bee1051f7704562d50d710ee3e8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "7a4a4e7e54c8d37995ac44e5136de669feabcd4f34d1a2ef9f67acd1a6d9c032"
    sha256 cellar: :any_skip_relocation, monterey:       "09a55aa9859f02fb92dac5b2e15bae7e76feaf72373c200db901ad77aff84765"
    sha256 cellar: :any_skip_relocation, big_sur:        "bec0badfa838e31dfb97d62bb959837e8017d2ba87815d32345a777dea5dd2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4296f92f9dbc320f34112c02838e59460addf5a991fbb03254be269cb8850657"
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