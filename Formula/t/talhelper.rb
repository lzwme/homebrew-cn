class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.13.tar.gz"
  sha256 "6799444c791b5a41fe7594a0916239c6f16cabb6cd30ba6e3fccf2baad3a04b5"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "091c76005b661c40c9353142538df38c57c20f5bd2ae9c9ea6afe7845ef8d398"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "091c76005b661c40c9353142538df38c57c20f5bd2ae9c9ea6afe7845ef8d398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091c76005b661c40c9353142538df38c57c20f5bd2ae9c9ea6afe7845ef8d398"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f9439960086d4aa2a93d3f1d8a26c37c1620693b9939458be0e368e2cff9b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5173ef0ed99d3a8b24e48f70b62b8edafd320fc093d77dc6a96cb6a4cd434e76"
    sha256 cellar: :any,                 x86_64_linux:  "85a2a72b87735095246f662813b5933236f44b176d5b4a5ce9efdb17636db9d3"
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