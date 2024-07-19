class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.56.tar.gz"
  sha256 "8c042f111eb73ab5c67b68485add043801902fab943c082e1eb7e570298cb7a6"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7285ca0ca60ebf1e3ed154111381f71c6a596d1c4272fb605a40ef7aa28c0572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "527259b512c5e931b6a1382326087859381f50e4b1e862009d2da25b79610914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "012bfd8522e5b67cc0ad25dcd959924cc600a4ba55a1f75bb04648b75cd568eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f9922c5fd3878363eb85f76944ae971963796c75f94476e7a9231c1a49dfa31"
    sha256 cellar: :any_skip_relocation, ventura:        "b7e01a045517cab493b5850b55500d165f50a10f83b731dba799ae3377661ede"
    sha256 cellar: :any_skip_relocation, monterey:       "a8b20eb4253476f8ba1a9c92301dbd9797f888292a2a64a4bb2da1827340d7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e0fccf340b95302071f039716d8ee4157d739b65556266b809797fa0f95ec3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end