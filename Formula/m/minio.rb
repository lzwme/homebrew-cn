class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-05-10T01-41-38Z",
      revision: "b5984027386ec1e55c504d27f42ef40a189cdb55"
  version "20240510014138"
  license "AGPL-3.0-or-later"
  head "https:github.comminiominio.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b7416e8224cbd9ba844e7f5ce3edf45559266b2135ec3772031ee4f31fbed34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b6b05b027a3da692ff2a17fa0c9dafb0f6189b2b43994f536c9035c2cc00e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f47307a8adada9453305aa9561efd561566ad899a50b2b0393cd463bd8672fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c240ff6cfd22e8965ccca2fc679d09ca346762115debd7f0b38e1748217ff95"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a493ae9f0ee7b677cef3de76cafc9d57cdf3055ad2c337ee3b391fb7acd991"
    sha256 cellar: :any_skip_relocation, monterey:       "fb778a8b947e69d719fd873faa4ad14453e119c1caccf5db5903cd7d9860b88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c699b21bb02573140dcd4f65a7955fceb68feff051421874b049f90c01512caf"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.comminiominiocmd.Version=#{version}
        -X github.comminiominiocmd.ReleaseTag=#{release}
        -X github.comminiominiocmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var"minio").mkpath
    (etc"minio").mkpath
  end

  service do
    run [opt_bin"minio", "server", "--certs-dir=#{etc}miniocerts", "--address=:9000", var"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logminio.log"
    error_log_path var"logminio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}minio --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}minio server --help 2>&1")
  end
end