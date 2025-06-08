class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt  Terramate  Atmos version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv4.7.0.tar.gz"
  sha256 "55f61bc1a03cd140d5f0102cd4bb2977f3b3b81f868ea1b330de2b66e2db39e7"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7201cda8f4a87962e446f68e2bbab86e0c0305ace48089cb86cf767ee86ef00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7201cda8f4a87962e446f68e2bbab86e0c0305ace48089cb86cf767ee86ef00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7201cda8f4a87962e446f68e2bbab86e0c0305ace48089cb86cf767ee86ef00"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2374e6523795688eeab27b146110c654e34d3f08dbc8600bdec2aff177557cf"
    sha256 cellar: :any_skip_relocation, ventura:       "c2374e6523795688eeab27b146110c654e34d3f08dbc8600bdec2aff177557cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81c76d361e1a0b18623f213f2aa6f8ffd26afc6588b5a17911e90a3fd8be209f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8b1dc041a2d1af58271f4e29e5b2a18febb2ec1bc3c62b748232e0f081a046"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"
    end
    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end