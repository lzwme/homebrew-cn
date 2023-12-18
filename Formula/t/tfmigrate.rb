class Tfmigrate < Formula
  desc "TerraformOpenTofu state migration tool for GitOps"
  homepage "https:github.comminamijoyotfmigrate"
  url "https:github.comminamijoyotfmigratearchiverefstagsv0.3.19.tar.gz"
  sha256 "2175782a4cfba523ebf0b075293306fcd62a79242d16e45bc2a24729dcb6a8ed"
  license "MIT"
  head "https:github.comminamijoyotfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e11c5d66131c3db0c156f4f0901b59b3793ae7e14e89fa918df048c5b7ac4fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f56b889cf7eed206150b0e7d7281b665287c13eab0bae1cc55945659928d9112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297e164bbead253a9f7e6a9431e98745959446508a24924e1df4dd50fb31d161"
    sha256 cellar: :any_skip_relocation, sonoma:         "78bca2d2b2d2660707d63ae52411df0ef96bc8937136215e6ea4327aa6f35189"
    sha256 cellar: :any_skip_relocation, ventura:        "12d252af39391eacfb9ec9bd6b090c38cb39b865e42489c2c25f91b84a3bb525"
    sha256 cellar: :any_skip_relocation, monterey:       "3caf84cb269d0e7837ef20c5ae80c310ef113a3904055362deff10461ae3ebea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1039f73553c891b84042a0ec99281bf77b7e1a50b5dc0c5c7e827b9b661c0192"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

    (testpath"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin"tfmigrate --version")
  end
end