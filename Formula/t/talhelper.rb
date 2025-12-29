class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.43.tar.gz"
  sha256 "a2cdc4062a61e35d270f265ed77cb97f9f17f82cd9423ed6c71f8fa8bcc250cc"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8a55a7f04591267c55530576608510b9c3b7a0b20c67d734ad6e4500f58667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8a55a7f04591267c55530576608510b9c3b7a0b20c67d734ad6e4500f58667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8a55a7f04591267c55530576608510b9c3b7a0b20c67d734ad6e4500f58667"
    sha256 cellar: :any_skip_relocation, sonoma:        "60ea2581d753fad91e9d43edab01cfe996e09ae571b214cfbcf5bc2689bf4320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2264372e53b83a94db95e2e5320655d0022d0800c26eb2c624561bdcfa95017c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff56ad1cfc8a83688bf1cb9001bab11c8f4f03bd3a8a870480a50465dbd34c7f"
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