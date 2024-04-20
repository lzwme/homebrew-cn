class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https:min.io"
  url "https:github.comminiominio.git",
      tag:      "RELEASE.2024-04-18T19-09-19Z",
      revision: "98f7821eb3f60a6ece3125348a121a1238d02159"
  version "20240418190919"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9de33c060fe57bd5c00e5e3a34de33d1895afa66ca1b409a7c1b7c79b559d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aede51919e36e191ae517904c224ce04eac70739a43ab9d5fcf0c851c67c6ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a5ac89db811f5334cb99fb23c12a0644b5c6f5d7c92c0d156b02c668231159"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebe961901890808ad81962688df5453e84326c0ed974588fedc0a9ed104759dd"
    sha256 cellar: :any_skip_relocation, ventura:        "58f4bf6f081ce2cd1bc8e6b15154b2ce451208137c8eea645ebc4f087536bb9e"
    sha256 cellar: :any_skip_relocation, monterey:       "69fcbeb2188fa8b8b9e26031c768fddda97774405f6df5e0ea5103ef3a2d7168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7e2b17503cd2df53ef9098764a09dd98d0c4e30d92398cfb64437f439eb438"
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