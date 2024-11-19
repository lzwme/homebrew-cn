class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.118.0.tar.gz"
  sha256 "fe80387fbcc07ac5487cf136e998b11c5cd2e4f240fde87d5813661abeac7aae"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9d0bf4267d29c95cafff477643a87f6c2de66ba542fc8c2d19693e4e6d3764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f9d0bf4267d29c95cafff477643a87f6c2de66ba542fc8c2d19693e4e6d3764"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f9d0bf4267d29c95cafff477643a87f6c2de66ba542fc8c2d19693e4e6d3764"
    sha256 cellar: :any_skip_relocation, sonoma:        "941f5ed03506414653ec43d50ad296b683e7381f6d3df3458e2c9c09fea67641"
    sha256 cellar: :any_skip_relocation, ventura:       "941f5ed03506414653ec43d50ad296b683e7381f6d3df3458e2c9c09fea67641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2120e50d17f72c003b51845f4f0681bcb41819051325651a113a72ea5f65cb62"
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