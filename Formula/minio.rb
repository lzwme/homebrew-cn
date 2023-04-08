class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-04-07T05-28-58Z",
      revision: "260a63ca73b09cf029a872554aceed809ae47231"
  version "20230407052858"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1993c7635c2adc92f2a59e078e934feab4d95f81b380170a6a7252a05b6f101"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "341dd343ae09ef06750220f1768ff6bbe37c3e1422f6a41054b8ae6b62dd5a1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb0c412ad1f9aa8ef6201d8faf4f8f724d5b9e9f72f703f3e4214fe62941a6dd"
    sha256 cellar: :any_skip_relocation, ventura:        "82eb0917f3d85fbd1c9a71c9d92b81897e17ff92b2eb7b2584aa7c4db2f80476"
    sha256 cellar: :any_skip_relocation, monterey:       "c75ae8a18808233c4b70c349098daa987acabe451ce2ab32174894791916a39b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c123bffffcfc960aeeff94d926e42e4ec4dfa13b5cfc331a1402955603a10cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945428030631d35730d3b920ebe7d4c4a1fa025ee733f540e3b380200c924e75"
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