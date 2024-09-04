class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.112.0.tar.gz"
  sha256 "3ac2402e56c1ffe8472ef5143da1cf931111681c300c287c8fb6aea21a1c2d15"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "926280890f02bd7e38a3fb9beaa65e1f71287cd005a763693c74801045df938d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "926280890f02bd7e38a3fb9beaa65e1f71287cd005a763693c74801045df938d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926280890f02bd7e38a3fb9beaa65e1f71287cd005a763693c74801045df938d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fe2db272d68dfedb5d1d6945230acb82eedefe0ee2e0cb6f6f278d19388af33"
    sha256 cellar: :any_skip_relocation, ventura:        "8fe2db272d68dfedb5d1d6945230acb82eedefe0ee2e0cb6f6f278d19388af33"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe2db272d68dfedb5d1d6945230acb82eedefe0ee2e0cb6f6f278d19388af33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0ae54b5c6a9363b9a48f5fd44a4e07a500b72b799a05c9a72fc24c1de88c4f"
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

    system "go", "build", *std_go_args(ldflags:), ".cmddoctl"

    generate_completions_from_executable(bin"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}doctl version")
  end
end