class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.9.tar.gz"
  sha256 "d7efb4e89bfa473e3abec8891217ac5d6d6bcc76799ec5f02f2b05d7bbf69ce3"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fcff55ec2fa8bf2a0386fa4686660cf0fa0b0b2a2285cd48f4816e523da5960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fcff55ec2fa8bf2a0386fa4686660cf0fa0b0b2a2285cd48f4816e523da5960"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fcff55ec2fa8bf2a0386fa4686660cf0fa0b0b2a2285cd48f4816e523da5960"
    sha256 cellar: :any_skip_relocation, sonoma:        "aec27130055a77339d19d0b9df70acc050744520b82e80b9180fbdf1854597f5"
    sha256 cellar: :any_skip_relocation, ventura:       "aec27130055a77339d19d0b9df70acc050744520b82e80b9180fbdf1854597f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d0d89541798c4a01b9f19afac538f83e609791110c30729b92e73f3e43bcb05"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
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