class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.1.tar.gz"
  sha256 "03903ba8d5414d96fc40edcea5f63a43dafb7aa73888f055f248608dc0451166"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddfebf6c41ba6babc4edb34e1c31a92b6d5dc030fa505714c487b23bfbdf1fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30ac1e27d289d4000a8da62f9744e1a05a70379a83c02112f8ddb296ca9afea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54e5d254f2ecf0722bff993c18e508398742560b055f7b9a137fb24bb85d08fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c07cc756ae8180122fab8bcf382ec894b71c913a656f2abcc69f5a94f6f9390"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1651ae9b73eea658ba30d5f0b5fb26d3a7d1a6bdaf60e15bd064bd5077296f"
    sha256 cellar: :any_skip_relocation, monterey:       "6a27782e28d0076bcd430742d75a22afafcd9c8cc5338cf20b1a98f4809b71b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d078afa75f77c56c96e18d2fbbd50549a6b06f544c62d6cc2f7a947b99e015"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end