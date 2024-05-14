class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.4.tar.gz"
  sha256 "657c6addb01437193e3907461022ed0a126181ecc32b740b033fef3fc4372535"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3bd995934389854e2f34a457d9f76128ab777124c888f9bdaf83de10442ff5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de501c15f2c66edd1d2d9d744fc93a028e0d7bbf5d6fed13632e31ac41584b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b06ca00e3b45d29a75652cd2d810e2ab67823f21c771a3ab954ce7292b057189"
    sha256 cellar: :any_skip_relocation, sonoma:         "5810a2fb853c9082d0af080debb1f34fb93fc8be4699dc48d6cafd5fd1e658ac"
    sha256 cellar: :any_skip_relocation, ventura:        "46b42e5d3cbd4151dd318b66c9cbab0055e91652e49d1a4d791d0677210a6a5e"
    sha256 cellar: :any_skip_relocation, monterey:       "6bad829958a49328189bfbcd7c51f398293bf579926ad8dfd17fbe7b45d0c35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b2685d093fff89345b9321b79b5358304b60f0977a97e1cf64138ab7fd29bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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