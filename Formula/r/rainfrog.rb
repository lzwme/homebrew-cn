class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https:github.comachristmascarlrainfrog"
  url "https:github.comachristmascarlrainfrogarchiverefstagsv0.2.14.tar.gz"
  sha256 "4e485fec86dd9b49b9ac9fc12037d33d471c714e1ef559c438638de9714ed98e"
  license "MIT"
  head "https:github.comachristmascarlrainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85473ae3f12d8e828627f445590585ff2dab57369b877467f7864508f43ec6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27817a12a9d96dfe893c3e4333a19acff8e042bb289a383ce7928fcd23c0ae0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "796a80fab7ddd2edcd052e89ce3e2566965a3051d5c97a9628d08109d18726b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f95544e53098d2d98d16d60fa0d22067f3b565516d10d5a83532cbf475ab43ae"
    sha256 cellar: :any_skip_relocation, ventura:       "344d570bd4280f08d1619bf7c2c7c21a22b0e63bc904861f3d111a09f537bdd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9a822fef42d247dae412fd5012085d6072dcfb8bd22873676cea4e6e111d85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}rainfrog --version")
  end
end