class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https:carapace.sh"
  url "https:github.comcarapace-shcarapace-binarchiverefstagsv1.1.0.tar.gz"
  sha256 "3c3ccfc8212ec74dc90885b1f029a955508aa942e446367bda8cd3b3d65ae8fd"
  license "MIT"
  head "https:github.comcarapace-shcarapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "add2b3c94f0029ff494383f0aab3d0d5b1d4261542a773a9dcee59104e9f2697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432886ede7332c5547ac5be1e60037b76aae666185f8db4c131818d63adef479"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71310b15e369f4edd068c21164f683669bede067149ce73009462c55c34b2632"
    sha256 cellar: :any_skip_relocation, sonoma:        "025e3b5f06fc7196de688cd01246b11ebb216366e2a15cfd1bcef5315c9b23e3"
    sha256 cellar: :any_skip_relocation, ventura:       "2e0cb0f32f7422dc2b531b8539b1dbbb027c01b942b6c1e1c2212736440af82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1d0abe470a0c24500434d7e96726076c366f9797be1a358da2a5877f6925b3"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "-tags", "release", ".cmdcarapace"

    generate_completions_from_executable(bin"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}carapace --version 2>&1")

    system bin"carapace", "--list"
    system bin"carapace", "--macro", "color.HexColors"
  end
end