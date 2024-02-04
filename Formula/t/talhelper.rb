class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.0.2.tar.gz"
  sha256 "7bfac573ead9d3d57381fa6c058fd488dd75fb52bf9accec7f7bd5acdd6ef6dd"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08e9c19c5f24843f90f117cdd3dc00f04c5b6792a4010a5a4f8fcc59c871b109"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c52062400f8fc5dcad6182fa3468e85406f63a061d636dc82c78b739659e8887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3a87d5f4f58ac97f39aa3ab7a797e07436fefe980dd8e0d43b221454651a452"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7c5190dccb59e3839ff907b5db320ef51a074b1576f682965e9b69abd22066a"
    sha256 cellar: :any_skip_relocation, ventura:        "2fbf26b9a22fd9cf0305197af0a44e517c6ebcc64f6146a2cb2f45e389f2bf30"
    sha256 cellar: :any_skip_relocation, monterey:       "a89dcb15712aca69bbda375d9f5e1b1e6ac5e376306e6fc69f86b1f97d48e908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418053d4daa67edce2f37a00ee66840766c2fe4cdbd8b87cf81472e3ece893fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end