class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.79.tar.gz"
  sha256 "46b3ff96eb66ada6bc6aa8bf96af4d05864916f4a4bc3c034389f60b0b7c4241"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d151ac7c9e234557b1465e0b21ee719a430a67785b37eebf235d87221aa4a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d151ac7c9e234557b1465e0b21ee719a430a67785b37eebf235d87221aa4a2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d151ac7c9e234557b1465e0b21ee719a430a67785b37eebf235d87221aa4a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8cee14475936862482ab2fb21f0b12e63dcb73e378aad35a4bd652a94601b7c"
    sha256 cellar: :any_skip_relocation, ventura:       "19fc662d9dfa58c4e591c7b259d1de175a4471289d9605666de912595f663b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c764372c76cbc9461019d5c77a8fe53c985b1353af15b5eb0f4cbf37562d67b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end