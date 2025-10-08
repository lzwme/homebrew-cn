class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.37.tar.gz"
  sha256 "a3255c994835af1afafa1ac99730d52886a7a9f7b7fcee355505ed93d26ee0dc"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de4e44e91aeb8004f4cc0faa989e4c851e6553ac32ea923e3ae1a982e9d363c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de4e44e91aeb8004f4cc0faa989e4c851e6553ac32ea923e3ae1a982e9d363c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4e44e91aeb8004f4cc0faa989e4c851e6553ac32ea923e3ae1a982e9d363c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "49164ce31b37982e21909348d84e996b684d80b81415f099e918278586c3ea3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d779dbd05aaec24fb99a917fbe55a128ab5e7555a8064e0d2c8b3240b35b0f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
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