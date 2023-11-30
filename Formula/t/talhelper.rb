class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://ghproxy.com/https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "6d8b3b1c46dddbd08c8341d2c74b8173d1d714f642847173025bdb1136d6254a"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce849ba91a232c00f58b36e8cf498114f7e02336307f9a053e88508c32f4689d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca9054e9f5f4f595ed56fad7fb2e88a460f349b2ca481c89619d13bfd9ca45a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ad456c828304bb3a236db320e37a6b9ab7fa76cad1e41ce1735dc85a823f64"
    sha256 cellar: :any_skip_relocation, sonoma:         "66a4790492121e8f29f10f053055f553d10a0398a52d651d921f6b2f507fee2b"
    sha256 cellar: :any_skip_relocation, ventura:        "39a40d2051e094bc2cc6343c7178101e73c993b58542d21d44eb4583519e6de0"
    sha256 cellar: :any_skip_relocation, monterey:       "a5159d195df7bbe07a084d45debe49db4b18f8e08a3f9f2e8f5c69ed5a7eca0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0eeafd127d9086136c2226e07403d5b5e6d42fef3ff1117196ca0abeac25ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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