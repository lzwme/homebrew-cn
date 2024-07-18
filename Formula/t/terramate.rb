class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.9.2.tar.gz"
  sha256 "4218654938bf2e84a43e9b5954405efbd20819ab85c0e9617ccb6eb139d954dd"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "781d2efb3b44f7754dffea0791d2c81cc023a8588722db95199cc33817edbfd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2020c744ace286ef0f0ae6657302df47ea1ffee2080d1798cc4a40f003081b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aefb3f7cca6dbc9ed135a0af651d5b19fab4eaa06697b4a1568665b4a7e138f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9d92a60c8d7a1a0585a6a37dd5c86f1652a28c04b4b179d7a6575e2271d5b6d"
    sha256 cellar: :any_skip_relocation, ventura:        "f53d07f294456f73b8a311f16745245a553c5b74abb6b61fbd852e37487bc9f6"
    sha256 cellar: :any_skip_relocation, monterey:       "645d086f31f9107e22ffd70e241a6fb6011a55731add92fef5de21ad4aee655f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8ebc022eea30cfed29a4b55b8ded37856d44cf80118ed5c4c29a5a11d2e37f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end