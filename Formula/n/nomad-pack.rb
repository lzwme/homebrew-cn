class NomadPack < Formula
  desc "Templating and packaging tool used with HashiCorp Nomad"
  homepage "https://github.com/hashicorp/nomad-pack"
  url "https://ghfast.top/https://github.com/hashicorp/nomad-pack/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "4865cc1490d3aeb48248133ec667162cb1199e379d592643ef024b9ac0f30640"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a7a85e186fd17535eaab79eaf8b289372cb586469ead0d732725d60ea9a29b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a7a85e186fd17535eaab79eaf8b289372cb586469ead0d732725d60ea9a29b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a7a85e186fd17535eaab79eaf8b289372cb586469ead0d732725d60ea9a29b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eda1d471d71c03e5d571fa56daf01aace68ae67b19da7ce2f59cb87cf5078f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1bcfcbe32bea180a74b23c41e8e1ee1fd4d45420f375db0d29b18797066df6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee0126393e00b05a7da76172d9a4226f2a70e3853500ad6016de31715b4bf22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/nomad-pack/internal/pkg/version.GitCommit=#{tap.user}
      -X github.com/hashicorp/nomad-pack/internal/pkg/version.GitDescribe=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"metadata.hcl").write <<~HCL
      app {
        url = ""
      }
      pack {
        name        = "test"
        description = "Test"
        version     = "0.1.2"
      }
    HCL

    (testpath/"variables.hcl").write <<~HCL
      variable "cpu" {
        type    = number
        default = 500
      }
      variable "memory" {
        type    = number
        default = 256
      }
    HCL

    (testpath/"templates/test.nomad.tpl").write <<~HCL
      resources {
        cpu    = [[ var "cpu" . ]]
        memory = [[ var "memory" . ]]
      }
    HCL

    assert_match <<~HCL, shell_output("#{bin}/nomad-pack render .")
      resources {
        cpu    = 500
        memory = 256
      }
    HCL

    assert_match version.to_s, shell_output("#{bin}/nomad-pack version")
  end
end