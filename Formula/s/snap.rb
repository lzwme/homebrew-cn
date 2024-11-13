class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https:snapcraft.io"
  url "https:github.comsnapcoresnapdreleasesdownload2.66.1snapd_2.66.1.vendor.tar.xz"
  version "2.66.1"
  sha256 "5fa662062562443b2a005ed1aad359d6cc0c74ffbb555af701a4c1f510896b7b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "292b51a255b4a21c81cfa59b0ed71b3a7f9dae5354147d9a19a7d6b03b36f48d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "292b51a255b4a21c81cfa59b0ed71b3a7f9dae5354147d9a19a7d6b03b36f48d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "292b51a255b4a21c81cfa59b0ed71b3a7f9dae5354147d9a19a7d6b03b36f48d"
    sha256 cellar: :any_skip_relocation, sonoma:        "581416d57a6ee973686987d903d2aa70e03c4643734aefbadfddbba7096438e3"
    sha256 cellar: :any_skip_relocation, ventura:       "581416d57a6ee973686987d903d2aa70e03c4643734aefbadfddbba7096438e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46941233bae0f8e31fd625e5334f313a0c149358ed8c7d39f616c8376627ae36"
  end

  depends_on "go" => :build
  depends_on "squashfs"

  def install
    system ".mkversion.sh", version.to_s
    tags = OS.mac? ? ["-tags=nosecboot"] : []
    system "go", "build", *std_go_args(ldflags: "-s -w"), *tags, ".cmdsnap"

    bash_completion.install "datacompletionbashsnap"
    zsh_completion.install "datacompletionzsh_snap"

    (man8"snap.8").write Utils.safe_popen_read(bin"snap", "help", "--man")
  end

  test do
    (testpath"pkgmeta").mkpath
    (testpath"pkgmetasnap.yaml").write <<~YAML
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    YAML
    system bin"snap", "pack", "pkg"
    system bin"snap", "version"
  end
end