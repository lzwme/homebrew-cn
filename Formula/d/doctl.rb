class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.116.1.tar.gz"
  sha256 "c075572209c16a00367281a86b42364f595ef340287e5436e7a8f333ad7de1d5"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff61059ffe082f4baca1b20d6ec23dc7acb5937ea0610c8a6bd7f4b140fb507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ff61059ffe082f4baca1b20d6ec23dc7acb5937ea0610c8a6bd7f4b140fb507"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ff61059ffe082f4baca1b20d6ec23dc7acb5937ea0610c8a6bd7f4b140fb507"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8506360e4f7ec6e6734f25ea14cedd33b55483bc2e27c480882703d16ff998"
    sha256 cellar: :any_skip_relocation, ventura:       "0c8506360e4f7ec6e6734f25ea14cedd33b55483bc2e27c480882703d16ff998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204300fa9ff3b38aaeca6fc4792587fb1cc4e6a4c69e1c44b2497e7efcffc2af"
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