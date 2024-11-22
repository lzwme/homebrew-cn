class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.119.1.tar.gz"
  sha256 "ff1f5a0a2cca9a4adf36d70f7a0dd43e9345fc8caed7692355fd7381ef01f914"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c95e59649de8692a0ce8a56122a036f71abfd299cc1dcef09d28eff2cbf76a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95e59649de8692a0ce8a56122a036f71abfd299cc1dcef09d28eff2cbf76a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c95e59649de8692a0ce8a56122a036f71abfd299cc1dcef09d28eff2cbf76a2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c8bda0fffd79c51fd6297f6f6902a061227ab2542847ea92b48126b2ec9976d"
    sha256 cellar: :any_skip_relocation, ventura:       "6c8bda0fffd79c51fd6297f6f6902a061227ab2542847ea92b48126b2ec9976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4a19715404ce274f38e56f43c2f17145b9e53b2ca525fcf0d8ed4292f6bdf2"
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