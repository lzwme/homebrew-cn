class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https:github.comsvenstarogenact"
  url "https:github.comsvenstarogenactarchiverefstagsv1.4.0.tar.gz"
  sha256 "5417cebb20b4ae61ba9f979a96feb61944c2c05065543b4c79a531f5fce7aad8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbdce5e8b91fe802899d25d3df634a0bd71ae704768b038a0afe26a7ecf46979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36a588c7d5fde0aefe765029bed1e5e4af173c11c5f4f446c344dacd10506f1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eef69cf0108ce0b6da1992ad2e4ac1dda2b5a5aaab2e22b1b625cae0a352221"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2326bd3ec36aeedc49da359810e915f8be14988a00ab15aff8bc45ec0874e9a"
    sha256 cellar: :any_skip_relocation, ventura:        "76a4e64b573c3d0553f0a0219a30736a3088e73b7e3c722e63e06f71e0d6a9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "0f22c4559b5d3498c45afae028ca7165bb93bf6c96e9f6da8fb0d43c74240c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "419cfca615d761631371d24b17e0d606be49657728ea6955a5fd3e04a265988d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"genact", "--print-completions")
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}genact --list-modules")
  end
end