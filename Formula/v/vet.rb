class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.2.tar.gz"
  sha256 "c5d2ddadabe3e102e565513806c79200df691409f9cbae9150e564b9406b92de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "870781b9139b1dd5bb76768a6d3a127448c531ff4053e00fa714f65a1a5a591f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4122f4b558da63c73ef6cd7a765baf0ca1969301feb105774914c99cc5ed9b89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e640bfe42f655ad69c2e25778a17ba0ae303284119c7bf89b5d39f592cebe829"
    sha256 cellar: :any_skip_relocation, sonoma:        "54be7da1e5ba19f171e531730d6ee1e06c191bec9f3bb2c03d119c5a3465b243"
    sha256 cellar: :any_skip_relocation, ventura:       "d2ea1f9137d25ebde85c30a189f03258d83ede4a0d07458917076f294862c64d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c7e5205630fd47b3d1867b049b33605f1f45ef2918d0b6def196110b637bbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end