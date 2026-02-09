class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://ghfast.top/https://github.com/yarlson/lnk/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "aeb60a34139af39fe9a495cf15b261e2c743dd757599737a1db36dd1ae997b96"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20085bbd583ce52186cbec36c213bc4ae6aae60fc66ea4a24e0af4e01b0ed8ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20085bbd583ce52186cbec36c213bc4ae6aae60fc66ea4a24e0af4e01b0ed8ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20085bbd583ce52186cbec36c213bc4ae6aae60fc66ea4a24e0af4e01b0ed8ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6a2b0a711fbddb9a493a4dee9f6b82bf13ff199fa106b2e307c00a703b64ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dbb89d967f4233593f2fe396038b5f50f247a4c995ba793234ca32ec3e85e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9ce81bb0758298bb85d26cec1b34eda869dc263d36d554944dced3a40aa467"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lnk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end