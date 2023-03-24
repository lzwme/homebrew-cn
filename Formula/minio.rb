class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-03-22T06-36-24Z",
      revision: "035791669eb43f90bc38cd68f3dc87f65d622993"
  version "20230322063624"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0f0bd8e1bfb2a913478d1c5bd5a57fc114e4683c1d64bdd5891b4e6f8bd82aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93aadab3c8555997b25d50e9c643a3a175624b3d185cd6ac5e49d94ec6cb9cf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd5e6e4ea86a2b5af96dd7e742e014d601f6e743e0078e50f351e2ae1ee2852a"
    sha256 cellar: :any_skip_relocation, ventura:        "8163748827916019d41418fb25e7957ff45804c787bdd6a28edf6ce310de9097"
    sha256 cellar: :any_skip_relocation, monterey:       "55ec1649fe4ee5284c567eaf611b14621109874d91db0903890fbe7747807f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e3450a1fb19dc11b2bd9ebcdb307fd20406677acd985842c592809c237b5ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "777479f72e825929e208d6868047b7573b1dded72f7671a6d49701d9dc8ae88b"
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