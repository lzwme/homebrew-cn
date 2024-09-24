class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.5.tar.gz"
  sha256 "ee27d5384243bee7dca3e4a9be0d939264313a73cf8f9be7949cabf49255021f"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e5455d34501313311ea4a14c0c92f69a18db7a16c586da9cc87947154504f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e5455d34501313311ea4a14c0c92f69a18db7a16c586da9cc87947154504f4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e5455d34501313311ea4a14c0c92f69a18db7a16c586da9cc87947154504f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fee9103d22cff34ab22122a67dea9b6f5ba671e4e8e127adb69ea635b9b5618"
    sha256 cellar: :any_skip_relocation, ventura:       "9fee9103d22cff34ab22122a67dea9b6f5ba671e4e8e127adb69ea635b9b5618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24e9b107e457c2e4c299901bff990255a9cb765ff09e8b2b5d0c0161731dde0"
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