class Tenv < Formula
  desc "OpenTofu  Terraform  Terragrunt version manager"
  homepage "https:tofuutils.github.iotenv"
  url "https:github.comtofuutilstenvarchiverefstagsv1.10.2.tar.gz"
  sha256 "36e8dd7830043c4a7a61d359cfb3f4dd9ad79218dcd23bdd7bdd3659fdbb973c"
  license "Apache-2.0"
  head "https:github.comtofuutilstenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aafec434ca9aaa15756a6cfa071d90cd5bd2d663a98e5e23b6151daa01a1583b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf912201197fde54dcc6ff3b604ede458323cd5ba68d713f542f538e15d15639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78c92bd2557d0b26b114508e1bfbb3535c381beb36fcdb6df157b04184943580"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c4aef1aa2c5ba18f5c746fb6ff63f0389720b96294b5d0a1b811e365ac075a6"
    sha256 cellar: :any_skip_relocation, ventura:        "2010a2988431d1c621de4af91ab6f32da55cf65e99cf1bc5b8ff16244ef1a6bf"
    sha256 cellar: :any_skip_relocation, monterey:       "c01825aaacd6639ea14314243e33cb5d72b55e4bc1f0fc1e2873e012963ba5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15dd04a7e4afa85d19792da9f4349c3a2614af962f2f549efa50ea708ccaafdc"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: binf), ".cmd#{f}"
    end
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}tenv --version")
  end
end