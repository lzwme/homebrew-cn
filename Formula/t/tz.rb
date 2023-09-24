class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://ghproxy.com/https://github.com/oz/tz/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "82fa7604f3abd3f224d0d6a52976e5de27127d41b2ef80507f3a964ea9b2ef58"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d09ca838daae5b17b86a7ac1f92404f88fc8bc3d7b0ef092c22a99be216a765c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83aaf5ea3205df997942013f5a6c8660c41ae6da4526d16d55335e5dabdccfc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83aaf5ea3205df997942013f5a6c8660c41ae6da4526d16d55335e5dabdccfc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83aaf5ea3205df997942013f5a6c8660c41ae6da4526d16d55335e5dabdccfc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5025f5757137041f632bbce18f6c62b64b3989b77ff9f5954cfaa476df2a166a"
    sha256 cellar: :any_skip_relocation, ventura:        "c5673576b5029313511c42bafd35fe8309cf023792222c1e25f7fd9a8656b2b4"
    sha256 cellar: :any_skip_relocation, monterey:       "c5673576b5029313511c42bafd35fe8309cf023792222c1e25f7fd9a8656b2b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5673576b5029313511c42bafd35fe8309cf023792222c1e25f7fd9a8656b2b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92db3447fdf82ca46731489658954d1fb9e28457e9ed714df9115dbed8b6b2e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "US/Eastern", shell_output("#{bin}/tz --list")

    assert_match version.to_s, shell_output("#{bin}/tz -v")
  end
end