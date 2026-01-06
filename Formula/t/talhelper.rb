class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.45.tar.gz"
  sha256 "50b958c50c3110346c950722ce900a32282a28654fb35468771c8e49c660f245"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a37d75286e3f702a85e5823b897e5e5f74546126f1a6dcf2d9a7fd4f4365d55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a37d75286e3f702a85e5823b897e5e5f74546126f1a6dcf2d9a7fd4f4365d55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a37d75286e3f702a85e5823b897e5e5f74546126f1a6dcf2d9a7fd4f4365d55"
    sha256 cellar: :any_skip_relocation, sonoma:        "438cf1b77f5676b4375a486c938d502176866c9de6925a690d9454f4740b6320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a8430ecf868f2f6a978ea91207e596f015f9e516fc115f37c5baa66a7ecb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3ac98815734d16a1b33c7b3a4c2378d973f1d93aec1a9b064782557635a428"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end