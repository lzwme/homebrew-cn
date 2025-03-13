class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https:github.comminiomc"
  url "https:github.comminiomc.git",
      tag:      "RELEASE.2025-03-12T17-29-24Z",
      revision: "c1d5d4cbb4caf05afef3ea06a91a56bd778336de"
  version "20250312172924"
  license "AGPL-3.0-or-later"
  head "https:github.comminiomc.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:RELEASE[._-]?)?([\dTZ-]+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6664bb82d01bcfbd5d05324c19a98c8f200b01f9391baea0ec1274e3f0ff6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba914981ff99303de89027ddac4b3f4ba8b19b01c4f3f2ff6d250ca0c212942"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49beafdca6f021c62cfb5de7ce485939e5ca896c1b16ded447d39347c678f086"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3bdd239ec5b14723e6ed399be6adfff6a0f636ffffa12e22b95dfe30f4b6c1d"
    sha256 cellar: :any_skip_relocation, ventura:       "ec06c6ec4ba770badc942180366bf026b5315e30ce541f69bda0ad5e64f959fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3111657b76dd04056c942b718aab8750a0c143235292aeebae97efbcfce5c7a4"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(T(\d+)-(\d+)-(\d+)Z, 'T\1:\2:\3Z')
      proj = "github.comminiomc"

      ldflags = %W[
        -s -w
        -X #{proj}cmd.Version=#{minio_version}
        -X #{proj}cmd.ReleaseTag=#{minio_release}
        -X #{proj}cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin"mc")
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}mc --version 2>&1")
                   .match((?:RELEASE[._-]?)?([\dTZ-]+))
                   .to_s
                   .gsub([^\d], ""),
                 "`version` is incorrect"

    system bin"mc", "mb", testpath"test"
    assert_path_exists testpath"test"
  end
end