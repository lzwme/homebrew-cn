class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.110.0.tar.gz"
  sha256 "eba3cfcd163f4f2baac9916247c5d1e6352c7969c8ae90b6938c8181af21e98c"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1829f503a638cc6a46fcba39977412a601999517e25d14e4a6e832854b3c3c59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb29d52ad70c07a942d7528e05fc0112d493868f9760f6f857fb0deddb599f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e162fd2d76ca9d58f0280ac5beda342358d673bcf748659d1c0ef4bf78dc40a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b70f46cbdc68ee799eeda6de66bb0e7adaa92e36f8b95669906ea24fab4d2d70"
    sha256 cellar: :any_skip_relocation, ventura:        "bcbcde456fb276d9fae788bcc5d9a4d69810b41892668db6f4a2926682505676"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d1ed56047d15eca7617ee3ab2558706a0004c5973f185bddd6312f5fc06d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027fa08d08d6a59ec3ecf3fb21594931483aea1dae31f7c000ac99abc31e253f"
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