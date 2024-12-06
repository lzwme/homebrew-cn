class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.7.tar.gz"
  sha256 "763b7fd5b93f2b83ddb7077235c27f7ff122c144ead51b20effbf30253e615be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4172eb1f0af1ab06a48aeae7dc8ed0f4a866912cc92d0d81e676a4b1fb61817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f41fd6451d0112e8ba3aa9368547d4dc706bc2f3df6ab4e5e39e5fb68cc8e35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3c2fc207aab3d46094dbc6773c7e783c7b51557cff57303c6a97e67f46eb7db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7551d0e227cc50c67361441b5e14b4b57e595d086b30acd395ec0695ad165828"
    sha256 cellar: :any_skip_relocation, ventura:       "6d723d73fde03e6e2e1a7dba5c61dcc14a0efc350fadf5babaab06ef8e3e2953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "122d6ab5e782f24653a29ef1c720c7b22864beb014f29bcc62c2755309353c4f"
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