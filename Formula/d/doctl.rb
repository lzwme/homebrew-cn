class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https:github.comdigitaloceandoctl"
  url "https:github.comdigitaloceandoctlarchiverefstagsv1.116.0.tar.gz"
  sha256 "4c1bbc7f081a8921b34736dbcaaf35bbd4225606d8718f8014ea9b9cc67eaad8"
  license "Apache-2.0"
  head "https:github.comdigitaloceandoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f25a222c2e0a742d93fd1f25306292614a56b861809066b01edd5aa36b2a6f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f25a222c2e0a742d93fd1f25306292614a56b861809066b01edd5aa36b2a6f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f25a222c2e0a742d93fd1f25306292614a56b861809066b01edd5aa36b2a6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5ef1f68a0cf0ac4e0bb60a1b18278cf02020c56212a8327edf219e2a8a71dbf"
    sha256 cellar: :any_skip_relocation, ventura:       "b5ef1f68a0cf0ac4e0bb60a1b18278cf02020c56212a8327edf219e2a8a71dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b2e58dfdda6e96d9363946570a16f51da66e1bea576b1832cab9cb4a1c730e"
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