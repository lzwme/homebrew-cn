class Snap < Formula
  desc "Tool to work with .snap files"
  homepage "https:snapcraft.io"
  url "https:github.comsnapcoresnapdreleasesdownload2.65.1snapd_2.65.1.vendor.tar.xz"
  version "2.65.1"
  sha256 "826f8fa8021400326c7be40ea2d45c2d3f80288b41effba21cd5677fde5c2db0"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "636a285dc8503de86d2faaa5dc3f2c74af0f0afce795b73ebacd46df3f7b6a96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "636a285dc8503de86d2faaa5dc3f2c74af0f0afce795b73ebacd46df3f7b6a96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636a285dc8503de86d2faaa5dc3f2c74af0f0afce795b73ebacd46df3f7b6a96"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1037d6a55a5af3927a2651a7432883c50c38ac052699735b145968a009e9b00"
    sha256 cellar: :any_skip_relocation, ventura:        "b1037d6a55a5af3927a2651a7432883c50c38ac052699735b145968a009e9b00"
    sha256 cellar: :any_skip_relocation, monterey:       "b1037d6a55a5af3927a2651a7432883c50c38ac052699735b145968a009e9b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd82ef101ce077bc0218d3d03f6b0bda39da1431115598f8f59137992d93c8ba"
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
    (testpath"pkgmetasnap.yaml").write <<~EOS
      name: test-snap
      version: 1.0.0
      summary: simple summary
      description: short description
    EOS
    system bin"snap", "pack", "pkg"
    system bin"snap", "version"
  end
end