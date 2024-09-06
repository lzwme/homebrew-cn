class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.2.tar.gz"
  sha256 "a1238f5712251cf06403b6e9cfd711115e295019cb0801b4250070aabf074233"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cdb1ad19dee6f53d03e39d2f4f96e3dc81cdf2b2d3dd0537678b043a2a5150f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "566a66addbd733495375d893804eb72f3ed991de1ec9ad06b22da8783dda5f83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21f791b56838c791db7764bf60aa03d211a70e2ded0dfff10f11de9d08f612b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c241695a0735963bf9bffca9f00a302f5de5e6899f499a710d79a5fd548d0dcf"
    sha256 cellar: :any_skip_relocation, ventura:        "5be54f25bbbbf59c020dfba5ad269934e43e6cad0fb25047091d75f159cb893d"
    sha256 cellar: :any_skip_relocation, monterey:       "b45cb53f8f06f40f6f1bd82fd4a84ce8d11ba5fdc5f7ccef38902fc2776a4853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68d88908a20ffbded81690a4c9aa1979101fde625c7bb27c796916052059a9b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end