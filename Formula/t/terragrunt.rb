class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.6.tar.gz"
  sha256 "e7ea06d73fb26dc1ae6785f53358fff2775658038d78dd54676a24cc390ee8d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc191c42d0f7c86c5891db78715ed79311fb23f414447794a082fa2276ca0f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfc191c42d0f7c86c5891db78715ed79311fb23f414447794a082fa2276ca0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfc191c42d0f7c86c5891db78715ed79311fb23f414447794a082fa2276ca0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "61bd746ba02581af8354a78224e6c3100c5d5ab448fb507c104a603e1a333420"
    sha256 cellar: :any_skip_relocation, ventura:       "61bd746ba02581af8354a78224e6c3100c5d5ab448fb507c104a603e1a333420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "232876f9bb71b727b53eb3c30bc0cb533f17023856718d0442818b7facc44885"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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