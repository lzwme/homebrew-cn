class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.37.0.tar.gz"
  sha256 "13af58413af8f5d41d72c955de0ed9863a53f286df5f848e3d68bcb070b54ef2"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80491ee2e4f3987dbcff483a0926cf6702c96753f5c44c3f5ec2a437693da501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a846d10baef4b84a02c4ef0e19f0477ffd18937b8ceb87d3570abe382eaee73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30ce4485fcd929958082df00da8f179891696ae3997c5b4c5b4f9ed4b28dae26"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b649f5e04fbd2db2d1be019bfd99cf30f5e71ab50912962d2cac7d1acebc41"
    sha256 cellar: :any_skip_relocation, ventura:       "434c179c08d9575deb46265194e8c13b016f65c1d3e8032831e93648188b529a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accf78bce36bbf68133d125710843a9a79ae5bc198cdedccfb634204de787d62"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"just", "--completions")
    (man1"just.1").write Utils.safe_popen_read(bin"just", "--man")
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}just --version")
  end
end