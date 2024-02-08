class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.5.18.tar.gz"
  sha256 "24a1377e9dd957817c14c1079a689029164a0bd4b5fda0a2f4226899904935d0"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "415e9cf73fa75ccc0b6ef73a995b44541d59156aebb03f0ea3d9298b2a01c005"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24776879933460defcae6e09e2ce90d44278133e88887ca4457412ac2ce11e56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24542952b4c9aca0955ddde3cd4011f4bb77df80d469d4daa6486f0b3ba4611f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdba6c41cbd3c92500170aa279a6ce548dc450b17f0e173c06f808323a35ca30"
    sha256 cellar: :any_skip_relocation, ventura:        "cd3aa9680b1cfc5b2daaee344a0f7195dde951338a00f0ab69ec25208462ead6"
    sha256 cellar: :any_skip_relocation, monterey:       "12d2989eec2aa89a42609c88aae64de064722cb203a8c78c2e08d624199afb1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa384cd81c954c7011712d2634018eb52763d41bd5c625de72288fe515cc9e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"mass")
    generate_completions_from_executable(bin"mass", "completion")
  end

  test do
    output = shell_output("#{bin}mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}mass version")
  end
end