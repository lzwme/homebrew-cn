class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://ghfast.top/https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "c36dec5abd7443a4bef3e00383c9a25b35606a99913762d92bbf0b5379a3c681"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0cd96a4c96bdd29ebcbe49bbaa2c475f940c7feb1add69436019441c768f3db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0cd96a4c96bdd29ebcbe49bbaa2c475f940c7feb1add69436019441c768f3db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0cd96a4c96bdd29ebcbe49bbaa2c475f940c7feb1add69436019441c768f3db"
    sha256 cellar: :any_skip_relocation, sonoma:        "b94906b3a76507c9a7c4b9f383054f677275180baa7af549fefde1f9d4d7e2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f268d624fc262639806bd6502e5b6f11222bf5c6e78bc3bbffbbd1d3ac865f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0c835a2e4fbe02e7e68922953ff3fb85260e45b6685a528e223a022a39150d"
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