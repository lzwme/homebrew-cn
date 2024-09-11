class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv3.2.2.tar.gz"
  sha256 "e233c24b2322eaf7b25844bf75941e1c8edb48827d0b6e48d749f9d922ed1471"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0f678decccc5afae48527157c660dee9cd1814f2cb1b97977d1f5acb4816da86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f678decccc5afae48527157c660dee9cd1814f2cb1b97977d1f5acb4816da86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f678decccc5afae48527157c660dee9cd1814f2cb1b97977d1f5acb4816da86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f678decccc5afae48527157c660dee9cd1814f2cb1b97977d1f5acb4816da86"
    sha256 cellar: :any_skip_relocation, sonoma:         "724c3a44fd2a885bfab6ec03a0ad3860b597dbc9c88c25d7cdaaf2d3e918e157"
    sha256 cellar: :any_skip_relocation, ventura:        "724c3a44fd2a885bfab6ec03a0ad3860b597dbc9c88c25d7cdaaf2d3e918e157"
    sha256 cellar: :any_skip_relocation, monterey:       "724c3a44fd2a885bfab6ec03a0ad3860b597dbc9c88c25d7cdaaf2d3e918e157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9e04eae671e0ee88ff1130fe187e0e329cb1a182e953a6c4b2c3ce51832b36"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"
    end
    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end