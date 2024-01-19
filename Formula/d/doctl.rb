class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.103.0.tar.gz"
  sha256 "ea8f351c3526babb7497688734fdc4ad2a2b456d78662e6bcedcdd3f9a8c1ce4"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15b78f56c0a35d9333109fc6483e8df31d0f8e52c68c0ed63a67287d548fd3b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "678f0258873b22c1ae1e04701a76d6c458a9acb28a3109e78e6719b71a30d443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8befb670d5da30e20f5497703ac4c53ac77de955d6a4f6191974794918d08a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d22006f5ebb15096c7e1142f406b83dd6e18c05ac62e78c404937b6b511cbcb8"
    sha256 cellar: :any_skip_relocation, ventura:        "d744490c3cee4df8c2d8b8d24081af637c97725a4a5093121c3574dc4a730b39"
    sha256 cellar: :any_skip_relocation, monterey:       "f9c5870f61b3cef04b2f2eeae59c4c8a5c16178ba5e24b1a171cb922c7fd964f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d37006259cfe0d1f54f7297280f3b815940d610ab297384b2519dec2c7010191"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.comdigitaloceandoctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end