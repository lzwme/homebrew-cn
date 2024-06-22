class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.6.0.tar.gz"
  sha256 "55079637aab1d5e2f38c219a3a980733e355d0c186993b35ef83f8252db9ecae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f76ccbe71786c0801044914476f66e80523e029f81905fe47297cee3ebd52bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e234ce16aee689206635ca10f01c6bb20dd3581df0850e3bdaa7827dd2df902d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fb562023cfe0ec3e2d587894aab19b5084b69fa95dedd8c0f92b7ecdcb02e65"
    sha256 cellar: :any_skip_relocation, sonoma:         "9323954a45e01e19b0d99300736cf962dca505e8a0ab1b76f1368c742062e613"
    sha256 cellar: :any_skip_relocation, ventura:        "f79bd83d5c81c713bc01fd8f457613fd0fc9f8eec598c2b2339d46f7ac4cd100"
    sha256 cellar: :any_skip_relocation, monterey:       "f85a681d8746eefd008c548fa68f06167a12557bcea4c8772870173224af3b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1de9e2aab1d266aa0d9f54a3c6ab0acb5a091cdae494bb95d4ef2d4b481ec9"
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