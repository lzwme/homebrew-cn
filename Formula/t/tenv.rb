class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.10.0.tar.gz"
  sha256 "75350c7b10305a798b5d231c6f2350dbc45b103cc5e2fb749b29043324a85526"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "518a2e6c2816e7cbc8dc97a5a1774eb21507bf442d7f1af78d52587010986864"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af2f8d25a9c028572b88f8f94655197143ac64d576915b704a1125b01f5c555c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b25e9bbb488ccaa617cfd532bc84ec62cbf4f063e524630a271ed70b5690ee5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dbcd7e61047be2361b6596058bb5ce3d8d6c771341ec98c1fe4f5ada9d874da"
    sha256 cellar: :any_skip_relocation, ventura:        "59b07694e8f85954a8f785b011c42b706166c7e7bdd44256246a63630686b8c6"
    sha256 cellar: :any_skip_relocation, monterey:       "b8be11fc3351ea3a12179ca23a6709fbcaead79f093a07eb67df0654298d5318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd6ce875aa07fd7ad281c0d774e79123263bb127ca81f0cbea7674d805a38d6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtenv"

    generate_completions_from_executable(bin"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end