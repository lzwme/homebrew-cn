class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.10.4.tar.gz"
  sha256 "22337924658523febca28d1ae498a1bead6978b1d75f8501fbc08419e0a42213"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf21a4136bf84cd6b09f1a20740eb38973d5706346c37659b2eabfb21bd093cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad2382aa4de1618c5664a8aea2b244c83635f5ff147e0e5157ea9db70903bf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5184ac8851df0aa15e19ab8b42c9b149da78e4f497e522d39cebb77431036220"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d77d37d1a9975f4f04c75149158b2992376d89a706154bea5e4b1a9e3e69fe"
    sha256 cellar: :any_skip_relocation, ventura:       "646f06873a82067beac9e302b0aa8ded09d1111da290289aba73913455d9a136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16e4a7f2ac589de6ad1617625087319c25d9492af3395a6af86edea13c2501bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcadc0b68a99a5b3a2e31efde6f3db01b3f9aff19ccccff0e0fe6f2feddca3fe"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1")

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end